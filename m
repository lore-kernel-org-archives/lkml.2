Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2APXug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:50:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38688 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2APXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:50:31 -0500
Date: Mon, 16 Jan 2012 15:50:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Subject: Re: [PATCH] config menu: move ZONE_DMA under a menu
In-Reply-To: <4F14811E.6090107@xenotime.net>
Message-ID: <alpine.DEB.2.00.1201161548580.16270@chino.kir.corp.google.com>
References: <4F14811E.6090107@xenotime.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Move the ZONE_DMA kconfig symbol under a menu item instead
> of having it listed before everything else in
> "make {xconfig | gconfig | nconfig | menuconfig}".
> 
> This drops the first line of the top-level kernel config menu
> (in 3.2) below and moves it under "Processor type and features".
> 
>           [*] DMA memory allocation support
>               General setup  --->
>           [*] Enable loadable module support  --->
>           [*] Enable the block layer  --->
>               Processor type and features  --->
>               Power management and ACPI options  --->
>               Bus options (PCI etc.)  --->
>               Executable file formats / Emulations  --->
> 
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks!
