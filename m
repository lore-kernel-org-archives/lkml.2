Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936941Ab0COWKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:10:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34116 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936810Ab0COWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:10:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5921"; a="36356728"
Subject: Re: [PATCH] Staging: dream:  generic_gpio: Use linux instead of
 asm uaccess.h
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chihau Chau <chihau@gmail.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100315053352.GC11552@elf.ucw.cz>
References: <1268622355-9966-1-git-send-email-chihau@gmail.com>
	 <20100315053352.GC11552@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 15:09:51 -0700
Message-ID: <1268690991.10000.24.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 06:33 +0100, Pavel Machek wrote:
> On Mon 2010-03-15 00:05:55, Chihau Chau wrote:
> > From: Chihau Chau <chihau@gmail.com>
> > 
> > This is moving toward using <linux/uaccess.h> instead of the old
> > <asm/uaccess.h> file.
> 
> Changelog does not match the patch.
> 
> ...plus, was the patch actually tested?
>                                                                         Pavel
> 
> > --- a/drivers/staging/dream/generic_gpio.c
> > +++ b/drivers/staging/dream/generic_gpio.c 

We need to do some sort of staging re-sync .. This file for instance
doesn't exist in the Google's tree any longer .. They moved to gpiolib,
although they still need cleanups on top of that.

Daniel



