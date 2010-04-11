Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0DKRFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:05:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42485 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752316Ab0DKRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:05:02 -0400
Date: Sun, 11 Apr 2010 19:05:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bernie Thompson <bernie@plugable.com>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: udlfb -- staging version does not work, external does
Message-ID: <20100411170535.GB22007@elf.ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz>
 <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
 <20100411164248.GA1998@elf.ucw.cz>
 <n2m480988181004111001h28d25ccavf6df2b4db62fadee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n2m480988181004111001h28d25ccavf6df2b4db62fadee@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-04-11 10:01:34, Bernie Thompson wrote:
> Pavel,
> 
> There are two separate issues you're discussing. Can you check the
> lockup issue with the git.plugable.com code?

Not easily, can we debug the "framebuffer does not work at all" before
debugging the "it also crashes the machine when compiled in" issue?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
