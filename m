Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1AUJQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:16:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62471 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1AUJQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:16:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BMLmU4Qz69Rvfi47C+I6K+9IYE5G4itO526x0wYGlLNEZLHMEliPfPHIlehtBTfksH
         VSkyJp2ofKJ9UgIeUcMeXrFaMphTEL+XOa4hml7LAj+hLLwGmT0H2BsvIrqGqhmYlHoD
         OgtjpzZsRC/kzovc5LwbFyvbgeFh1LUnmTXz8=
Message-ID: <4D394EF3.5000805@gmail.com>
Date: Fri, 21 Jan 2011 10:16:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <4D25CF4A.9090202@gmail.com> <4D38538E.9070104@gmail.com> <201101202202.01089.rjw@suse.com>
In-Reply-To: <201101202202.01089.rjw@suse.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 10:02 PM, Rafael J. Wysocki wrote:
> In that case the next step would be to build the kernel with
> CONFIG_PM_ADVANCED_DEBUG set and try to switch the async flag for individual
> devices (it is located is /sys/devices/.../power/ for each device).
> 
> For example, I wonder if it is sufficient to unset it for all USB devices.

Ok, I added
for aa in /sys/bus/usb/devices/*/power/async; do
        echo disabled > $aa
done
to /etc/init.d/boot.local. Let's see :).

thanks,
-- 
js
