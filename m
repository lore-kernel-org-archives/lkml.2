Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab1ENQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:14:58 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:59460 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753297Ab1ENQOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:14:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PqrPsm1L/AIBW9M9mfGj9qipvGH2iA4aw450Dy5zXGlC5UD/1s2bv31E6Kp/PjGlUW6e6qZxm5xkCGX2qG+4srXuPZMC4y7ITjeHFQ3/bMu8MCZ53ULYGm2v5n1toUWm;
Date: Sat, 14 May 2011 09:14:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tiago Vignatti <tiago.vignatti@nokia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: vgaarbiter: fix typos v2
Message-Id: <20110514091452.4172ecc1.rdunlap@xenotime.net>
In-Reply-To: <20110514125152.20518a22@absol.kitzblitz>
References: <20101201023457.739373c7@absol.kitzblitz>
	<20101201164141.abc97309.rdunlap@xenotime.net>
	<20101206092544.68cb5036@jbarnes-desktop>
	<20101206093353.18a5a411.rdunlap@xenotime.net>
	<20110514125152.20518a22@absol.kitzblitz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 May 2011 12:51:52 +0200 Nicolas Kaiser wrote:

> Fixed typos.
> 
> v2: Incorporated changes by Randy Dunlap.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> * Randy Dunlap <rdunlap@xenotime.net>:
> > On Mon, 6 Dec 2010 09:25:44 -0800 Jesse Barnes wrote:
> 
> > > Randy, I assume you'll pick this up once you receive a version you're
> > > ok with?
> > 
> > I wasn't sure who would, but I can do that.
> 
> Sorry for the delay. I completely forgot about this patch.

Applied, thanks.


>  Documentation/vgaarbiter.txt |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/vgaarbiter.txt b/Documentation/vgaarbiter.txt
> index 43a9b06..4710230 100644
> --- a/Documentation/vgaarbiter.txt
> +++ b/Documentation/vgaarbiter.txt
> @@ -14,11 +14,10 @@ the legacy VGA arbitration task (besides other bus management tasks) when more
>  than one legacy device co-exists on the same machine. But the problem happens
>  when these devices are trying to be accessed by different userspace clients
>  (e.g. two server in parallel). Their address assignments conflict. Moreover,
> -ideally, being an userspace application, it is not the role of the the X
> -server to control bus resources. Therefore an arbitration scheme outside of
> -the X server is needed to control the sharing of these resources. This
> -document introduces the operation of the VGA arbiter implemented for Linux
> -kernel.
> +ideally, being a userspace application, it is not the role of the X server to
> +control bus resources. Therefore an arbitration scheme outside of the X server
> +is needed to control the sharing of these resources. This document introduces
> +the operation of the VGA arbiter implemented for the Linux kernel.
>  
>  ----------------------------------------------------------------------------
>  
> @@ -39,7 +38,7 @@ I.1 vgaarb
>  The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
>  scans all PCI devices and adds the VGA ones inside the arbitration. The
>  arbiter then enables/disables the decoding on different devices of the VGA
> -legacy instructions. Device which do not want/need to use the arbiter may
> +legacy instructions. Devices which do not want/need to use the arbiter may
>  explicitly tell it by calling vga_set_legacy_decoding().
>  
>  The kernel exports a char device interface (/dev/vga_arbiter) to the clients,
> @@ -95,8 +94,8 @@ In the case of devices hot-{un,}plugged, there is a hook - pci_notify() - to
>  notify them being added/removed in the system and automatically added/removed
>  in the arbiter.
>  
> -There's also a in-kernel API of the arbiter in the case of DRM, vgacon and
> -others which may use the arbiter.
> +There is also an in-kernel API of the arbiter in case DRM, vgacon, or other
> +drivers want to use it.
>  
>  
>  I.2 libpciaccess
> @@ -117,9 +116,8 @@ Besides it, in pci_system were added:
>      struct pci_device *vga_default_dev;
>  
>  
> -The vga_count is usually need to keep informed how many cards are being
> -arbitrated, so for instance if there's only one then it can totally escape the
> -scheme.
> +The vga_count is used to track how many cards are being arbitrated, so for
> +instance, if there is only one card, then it can completely escape arbitration.
>  
>  
>  These functions below acquire VGA resources for the given card and mark those
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
