Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1H0RFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 13:05:23 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:34524 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1H0RFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 13:05:21 -0400
Date: Sat, 27 Aug 2011 19:05:38 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Joe Perches <joe@perches.com>
Cc: Andy Walls <awalls@md.metrocast.net>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] [media] cx18: Use current logging styles
Message-ID: <20110827190538.21357785@tele>
In-Reply-To: <1314463352.6852.5.camel@Joe-Laptop>
References: <cover.1313966088.git.joe@perches.com>
	<29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com>
	<1314182047.2253.3.camel@palomino.walls.org>
	<1314222175.15882.8.camel@Joe-Laptop>
	<1314451740.2244.7.camel@palomino.walls.org>
	<1314463352.6852.5.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Aug 2011 09:42:32 -0700
Joe Perches <joe@perches.com> wrote:

> Andy, I fully understand how this stuff works.
> You apparently don't (yet).
> 
> Look at include/linux/printk.h
> 
> #ifndef pr_fmt
> #define pr_fmt(fmt) fmt
> #endif
> 
> A default empty define is used when one
> is not specified before printk.h is
> included.  kernel.h includes printk.h

Hi Joe,

Yes, but, what if pr_fmt is redefined in some driver specific include
by:

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

(in gspca.h for example) ?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
