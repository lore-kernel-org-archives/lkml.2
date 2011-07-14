Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1GNWjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:39:23 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:36895 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab1GNWjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:39:22 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: large initramfs causes h/w reset after decompressing
Date: Thu, 14 Jul 2011 15:32:59 -0700
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>
References: <201107140906.46404.jzb2@aexorsyst.com> <4E1F5C20.8000008@zytor.com>
In-Reply-To: <4E1F5C20.8000008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107141532.59383.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 July 2011 02:14:08 pm H. Peter Anvin wrote:
> On 07/14/2011 09:06 AM, John Z. Bohach wrote:
> > I have a large initramfs cpio file, about 890 MB, which expands to
> > 2.7 GB, and am running on linux-2.6.36.1, in 64-bit mode with 8 GB
> > of physical RAM.
> >
> > Upon loading the initramfs, I see the message "Decompressing..."
> > for a few seconds, and then comes a reset.
> >
> > This question has come up before...is there some sort of max size.
> > that I am exceeding?  With 8 GB of physical memory and 64-bit arch.
> > (AMD-II), certainly seems that there should be enough memory, no?
> >
> > Thanks...
>
> What bootloader are you using?  There are some bootloaders which
> don't allocate the initramfs in a very good spot.
>
> 	-hpa

I've actually gotten the improbable to work, and am PXE booting via 
syslinux and dhcp.

It all works fine with an initramfs of ~20 MB, but that's quite a diff. 
from 2.7 GB of expanded /root (890 MB cpio.tar.gz file).

But excuse my ignorance, I don't see the relevance of your 
question...the initramfs is part of the kernel itself...I simply load 
the kernel bzImage (all 890 MB) and that's where its all at...this is 
_not_ an initrd.

--john
