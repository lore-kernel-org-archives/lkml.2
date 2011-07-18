Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1GRPq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:46:27 -0400
Received: from mail.perches.com ([173.55.12.10]:4129 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1GRPq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:46:26 -0400
Subject: Re: [PATCH 30/30 v2] Staging: comedi: fix printk() issue in
 das16m1.c
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ravishankar <ravishankarkm32@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <alpine.LNX.2.00.1107181139270.2483@swampdragon.chaosbits.net>
References: <[PATCH]Staging: comedi: fix printk() issue in das16m1.c>
	 <1310982260-957-1-git-send-email-ravishankarkm32@gmail.com>
	 <alpine.LNX.2.00.1107181139270.2483@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 08:46:24 -0700
Message-ID: <1311003984.2286.89.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 11:43 +0200, Jesper Juhl wrote:
> On Mon, 18 Jul 2011, Ravishankar wrote:
> > -	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
> > +	printk(KERN_INFO " requesing the I/O region from 0x%lx-0x%lx 0x%lx-0x%lx",
> Correct spelling is "requesting" and the "from" should either have a 
> matching "to" or just be dropped IMHO.
> Personally I'd just make it:
> " requesting I/O region 0x%lx-0x%lx 0x%lx-0x%lx"
[]
> I think the original text was better.

KERN_INFO is the wrong level.

Just log the errors at KERN_ERR/pr_err and make the rest
pr_debug or delete them.

