Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab0I0PZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:25:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49023 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596Ab0I0PZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ax9w+3ACeuwxXf0KzqUYqSrRck/X1PrUNGL7A45/acjPb60T+KdElwJ7kAcre0Iapi
         KaVzHLSrPvvLljVb9V59GOUf10NOT7rhKmU9B1z1UDgFFtBVVQJww4ISzt5+AkHKR7az
         7PIzix5vCKa63JZx4z/M4Oeq/+jCvtPbpIWL8=
Message-ID: <4CA0B768.5050304@gmail.com>
Date: Mon, 27 Sep 2010 17:25:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org
Subject: Re: i915 flickering [was: mmotm 2010-09-22-16-11 uploaded]
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org> <4CA06514.1080704@gmail.com>
In-Reply-To: <4CA06514.1080704@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 11:34 AM, Jiri Slaby wrote:
> On 09/23/2010 01:12 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
> 
> Hi, it introduced a regression against 2010-09-15-16-21 in i915. The
> screen, especially in thunderbird and firefox screen elements, flickers.
> Is this known/is there a patch for this already?

BTW. right now, probably as a result of this, I got:
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
(awaiting 990243 at 990230)

like in the glxgears report posted earlier today. But in this case, X
survived... Except selected text is no longer blue, but white and
another anomalies.

> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
> Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
>         Subsystem: Intel Corporation 82G33/G31 Express Integrated
> Graphics Controller
>         Flags: bus master, fast devsel, latency 0, IRQ 42
>         Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
>         I/O ports at ec00 [size=8]
>         Memory at d0000000 (32-bit, prefetchable) [size=256M]
>         Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [d0] Power Management version 2
>         Kernel driver in use: i915
> 
> thanks,
-- 
js
