Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0DKRfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:35:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50735 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752412Ab0DKRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:35:43 -0400
Date: Sun, 11 Apr 2010 19:36:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bernie Thompson <bernie@plugable.com>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: udlfb -- staging version does not work, external does
Message-ID: <20100411173614.GA24266@elf.ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz>
 <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
 <20100411170117.GA22007@elf.ucw.cz>
 <p2s480988181004111005kdeb479ddzd3719799f140f4a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <p2s480988181004111005kdeb479ddzd3719799f140f4a9@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> I don't think redirects like that will work.  The fbcon module loads
> >> against one fb, and can only be switch with utilities like
> >> "fbset"

I tried playing with fbset, but it seems to only set
videomodes. Ideally, I'd like to send kernel consoles to /dev/fb1, but
that does not seem possible.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
