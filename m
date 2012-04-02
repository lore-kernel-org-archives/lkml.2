Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2DBPE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:04:56 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36013 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752707Ab2DBPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:04:45 -0400
Message-ID: <4F79C006.8040807@xenotime.net>
Date: Mon, 02 Apr 2012 08:04:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexi Somebody <alexi.nones@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PROBLEM: Kconfig documenation typos
References: <CAH9_E90HZcV2XPDUtbat42KQjeJOp8yGW3aUG9PiJJzQT3+swg@mail.gmail.com>
In-Reply-To: <CAH9_E90HZcV2XPDUtbat42KQjeJOp8yGW3aUG9PiJJzQT3+swg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 02:14 AM, Alexi Somebody wrote:

> I found a couple of typographical errors on lines 414 and 424 of,
> 
> Kernel Version: Linux 3.4.0-rc1
> 
> [linux/kernel/git/torvalds/linux.git] / drivers / usb / host / Kconfig
> 
>  408 config USB_OHCI_HCD_PLATFORM
>  409         bool "Generic OHCI driver for a platform device"
>  410         depends on USB_OHCI_HCD && EXPERIMENTAL
>  411         default n
>  412         ---help---
>  413           Adds an OHCI host driver for a generic platform device, which
>  414           provieds a memory space and an irq.
>  415
>  416           If unsure, say N.
>  417
>  418 config USB_EHCI_HCD_PLATFORM
>  419         bool "Generic EHCI driver for a platform device"
>  420         depends on USB_EHCI_HCD && EXPERIMENTAL
>  421         default n
>  422         ---help---
>  423           Adds an EHCI host driver for a generic platform device, which
>  424           provieds a memory space and an irq.
> 
> 
> It should be "provides" rather than "provieds" on line 414 and 424.


Can you send a patch to correct those 2 lines?

-- 
~Randy
