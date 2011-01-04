Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab1ADXil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:38:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab1ADXik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:38:40 -0500
Date: Tue, 4 Jan 2011 15:37:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Sanders <support@simtec.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds/h1940: Use gpiolib for latch access / fix build
 failure
Message-Id: <20110104153725.2f3fede2.akpm@linux-foundation.org>
In-Reply-To: <201012100016.58130.anarsoul@gmail.com>
References: <1291932292-16049-1-git-send-email-peterhuewe@gmx.de>
	<201012100016.58130.anarsoul@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 00:16:57 +0200
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> On Friday 10 December 2010 00:04:52 Peter Huewe wrote:
> > This patch fixes a build failure by converting leds-h1940.c to use
> > gpiolib for latch access introduced by 14477095abc6
> > (ARM: h1940: Use gpiolib for latch access)
> > 
> > Unfortunately this driver was not converted back then.
> 
> I sent similar patch (however, my patch does gpio_request/gpio_free) ~month 
> ago.
> 
> Here's link:
> http://www.spinics.net/lists/arm-kernel/msg103429.html
> 

So which patch to use?

I queued Peter's patch because it's simpler.  I queued it for
2.6.38-rc1, taged for backporting into 2.6.37.x, so we have a bit of
time to think about it.

