Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963Ab0HFTmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:42:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761145Ab0HFTmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:42:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Date: Fri, 6 Aug 2010 21:40:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20100805213528.GA13794@kroah.com> <AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com> <20100806185147.GB23853@suse.de>
In-Reply-To: <20100806185147.GB23853@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008062140.37482.arnd@arndb.de>
X-Provags-ID: V02:K0:saOf+AJU5a1StCeMuIAU9VC6vu7Xg4bgiz3okcJs37s
 GW6dA67Mcgd5znI5Qp0hym/jy/no0LFqcNLi519EPU+i4c+ouC
 Ux0jRG29LYLLSq9bxSUNpzC/17CGEfJ8YgLNeJKGoE1j4GG/Pp
 cMFrcFhDP3ZQwtvgmzfFQFe/NsMM5MdJBO/lgx17ezZJwg8/+9
 59JGFFy9L+4XR5Lx1AWIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 20:51:47 Greg KH wrote:
> On Fri, Aug 06, 2010 at 11:40:15AM -0700, Linus Torvalds wrote:
> > 
> > Do do the highlander thing on that crud. Cut it off at the head, and
> > make sure it never ever comes back to life.
> 
> Arnd and Alan, I'll drop the BKL portion of this patch series and
> regenerate something to get the other tty patches to Linus.
> 
> Care to redo the patch series and just drop the BKL for good?
> 

I'm sending you a new version of patch 43, everything else should just
remain the same AFAICT. I've given it a quick sniff test and it still
works the same way as the kernel I've been running for the past months
with CONFIG_TTY_MUTEX enabled.

	Arnd
