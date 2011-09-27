Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab1I0Pko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:40:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1I0Pkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110927141326.GG10999@longonot.mountain>
References: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
	<20110927141326.GG10999@longonot.mountain>
Date: Tue, 27 Sep 2011 17:40:41 +0200
Message-ID: <CAGH8bx77JmmpOJCScSm287NCaj3wxMPHuT0C6meycsRZ6O68oA@mail.gmail.com>
Subject: Re: [PATCH] staging: comedi: Added log subjects to printk()s in pcmmio
From: morbid-rsa <morbidrsa@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        morbidrsa@googlemail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The KERN_ERR stuff is only supposed to be used at the start of the
> line of output.  (The previous KERN_INFO printk didn't have a new
> line at the end).
>
> All this code needs to be rewritten so each printk() only prints
> one line.  Otherwise you could get messages printed out in the
> middle of other messages and it looks like crap.
>

*args*, sorry for messing it up, I will take care of it.

> This code is trickier than it looks.  Quite a few newbies have run
> into trouble here.  My advice is to start with something that looks
> tricky so at least if you mess up, you were doing something awesome.
> :)
>
> regards,
> dan carpenter
>
>

Thanks for the advice :D

regards,
Johannes
