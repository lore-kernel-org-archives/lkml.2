Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab1FWVxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:53:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520Ab1FWVxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:53:53 -0400
Date: Thu, 23 Jun 2011 14:53:40 -0700
From: Greg KH <gregkh@suse.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andres More <more.andres@gmail.com>,
        Daniel Kenji Toyama <kenji.toyama@gmail.com>,
        Jim Lieb <lieb@canonical.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: Excessive frame size
Message-ID: <20110623215340.GA11333@suse.de>
References: <20110623101001.GA14199@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110623101001.GA14199@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:10:01AM +0100, Ralf Baechle wrote:
> In a MIPS allyesconfig build I got the following warning:
> 
>   CC [M]  drivers/staging/vt6656/int.o
> drivers/staging/vt6656/iwctl.c: In function ‘iwctl_giwaplist’:
> drivers/staging/vt6656/iwctl.c:787:1: warning: the frame size of 1288 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> That's a huge stackpig already on a 32-bit kernel and it will only be bigger
> on a 64-bit kernel!

Yes it is, that's why people are rewriting this from scratch in a "real"
driver so we can delete this one soon :)

greg k-h
