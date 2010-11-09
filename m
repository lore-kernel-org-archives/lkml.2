Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0KIVIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:08:43 -0500
Received: from mail.perches.com ([173.55.12.10]:4786 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0KIVIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:08:42 -0500
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to
 include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109210030.GI3099@thunk.org>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
	 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
	 <1289328235.1823.108.camel@Joe-Laptop>
	 <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
	 <1289330276.1823.125.camel@Joe-Laptop>  <20101109210030.GI3099@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 13:08:40 -0800
Message-ID: <1289336920.28590.44.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 16:00 -0500, Ted Ts'o wrote:
> On Tue, Nov 09, 2010 at 11:17:56AM -0800, Joe Perches wrote:
> > Differences in logging.h to original kernel.h
> > were done for cleanliness and checkpatch.
> Yet another reason why I detest mindless use of checkpatch.

If it makes you happier, I didn't use it here nor do I
generally use checkpatch, (just ask Andrew Morton), I just
wrote that more as a shorthand for kernel style conformance.

> I **really** dislike patches that try to do any kind of
> cleanup (checkpatch.pl or otherwise) at the same time as they move
> code around.

So fine, I'll do a minimal code movement only patch
followed by a style cleansing patch.

Anyone else have an opinion on using logging.h vs printk.h
as an include name?


