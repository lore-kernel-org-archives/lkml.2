Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0I0JhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:37:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65167 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab0I0JhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bX7vfdeNTMXqgPAj/cWVHL7Wckbyxm2mzOFXxUR3uW3wiJKj5T5NnaPX+yrzb927Y4
         EhE04UQ5xmgbnh21s+8AiBzfGL0bD+xMDDpnKw7hZImjajEuhp6lBCvE7mQPHVy59RPT
         AmQtY4KIJ17QbcD/kR6XtOP/k9AeVEhb18jBM=
Message-ID: <4CA065B8.1060206@gmail.com>
Date: Mon, 27 Sep 2010 11:36:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk
Subject: i915: glxgears causes GPU hang [was: mmotm 2010-09-22-16-11 uploaded]
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
In-Reply-To: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 01:12 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to

Hi, when I run glxgears in this kernel, X crashes. It happens also with
older releases and I don't know what is the first defunct.

In the log there is:
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
(awaiting 2 at 0)

00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation 82G33/G31 Express Integrated
Graphics Controller
        Flags: bus master, fast devsel, latency 0, IRQ 42
        Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
        I/O ports at ec00 [size=8]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Kernel driver in use: i915

thanks,
-- 
js
