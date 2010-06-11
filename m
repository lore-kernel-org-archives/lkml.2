Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0FKHa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:30:56 -0400
Received: from mail4.comsite.net ([205.238.176.238]:48882 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab0FKHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:30:55 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.20.111.250;
To: "H. Peter Anvin" <hpa@zytor.com>
From: Milton Miller <miltonm@bga.com>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs
 	alignment
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org> 	<1276068030_13535@mail4.comsite.net> <AANLkTin_MR82jafZkkzfv33dO6DqyFnHUiU4g6luXB_0@mail.gmail.com> <4C11CEAA.5020703@zytor.com>
In-Reply-To: <4C11CEAA.5020703@zytor.com>
Date: Fri, 11 Jun 2010 02:30:50 -0500
X-Originating-IP: 71.20.111.250
Message-ID: <1276241450_14430@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 at around 22:50:34 -0700, H. Peter Anvin wrote:
> On 06/09/2010 12:42 AM, Mike Frysinger wrote:
> > 
> > i have no problem changing the default to 4 since it works fine on
> > Blackfin systems.  your analysis of the source alignment also seems
> > reasonable ... i assume that the 8 byte fields in the source cpio
> > arent referenced directly, otherwise it'd cause problems on 64bit
> > systems that require 64bit values to be naturally aligned.
> > 
> > beyond that, i dont see why any larger alignment values would be
> > required since this source archive isnt executed directly.  it gets
> > expanded into a ramfs and then freed with the rest of the init stuff.
> > 
> 
> We have talked for a long time about incrementally freeing the initramfs
> as it is decoded, which might help systems which are using most of their
> memory for an initramfs image...

at which time the author of said theoritcal patch that might possibly
need page alignment would only need to update vmlinux.lds.h and not all
the architectures vmlinux.lds.S files.

milton
