Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0DARaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:30:03 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37003 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755075Ab0DAR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:29:56 -0400
Date: Thu, 1 Apr 2010 19:29:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Chihau Chau <chihau@gmail.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream:  generic_gpio: Use linux instead of
 asm uaccess.h
Message-ID: <20100401172949.GA2049@elf.ucw.cz>
References: <1268622355-9966-1-git-send-email-chihau@gmail.com>
 <20100315053352.GC11552@elf.ucw.cz>
 <1268690991.10000.24.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268690991.10000.24.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-15 15:09:51, Daniel Walker wrote:
> On Mon, 2010-03-15 at 06:33 +0100, Pavel Machek wrote:
> > On Mon 2010-03-15 00:05:55, Chihau Chau wrote:
> > > From: Chihau Chau <chihau@gmail.com>
> > > 
> > > This is moving toward using <linux/uaccess.h> instead of the old
> > > <asm/uaccess.h> file.
> > 
> > Changelog does not match the patch.
> > 
> > ...plus, was the patch actually tested?
> >                                                                         Pavel
> > 
> > > --- a/drivers/staging/dream/generic_gpio.c
> > > +++ b/drivers/staging/dream/generic_gpio.c 
> 
> We need to do some sort of staging re-sync .. This file for instance
> doesn't exist in the Google's tree any longer .. They moved to gpiolib,
> although they still need cleanups on top of that.

Yep. I hoped Google would just start using the stuff once it hit
staging, but...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
