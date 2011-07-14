Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1GNXlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:41:49 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:39893 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1GNXls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:41:48 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: large initramfs causes h/w reset after decompressing
Date: Thu, 14 Jul 2011 16:35:07 -0700
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>
References: <201107140906.46404.jzb2@aexorsyst.com> <201107141532.59383.jzb2@aexorsyst.com> <4E1F7B40.6030705@zytor.com>
In-Reply-To: <4E1F7B40.6030705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107141635.07673.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But excuse my ignorance, I don't see the relevance of your
> > question...the initramfs is part of the kernel itself...I simply
> > load the kernel bzImage (all 890 MB) and that's where its all
> > at...this is _not_ an initrd.
>
> Ah, interesting.  You didn't say that.  That does change some
> things... I would not at all be surprised if the kernel decompressor
> doesn't handle that very well...
>

Sorry, I thought initramfs would be clear on its own that its not 
initrd, but I guess some people do use it interchangeably.  Anyway, I 
have some experience in programming, so is there anything you could 
suggest that I might tweak to test your theory on the decompressor?  Or 
would this be more of a kernel VM allocator issue?  Also, would 
ramdisk_size have any bearing on this?

--john

