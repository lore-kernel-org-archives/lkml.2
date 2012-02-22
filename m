Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2BVLVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 06:21:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2BVLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 06:21:53 -0500
Date: Wed, 22 Feb 2012 11:21:44 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Pradheep Shrinivasan <pradheep.sh@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        lucas.demarchi@profusion.mobi, devel@driverdev.osuosl.org,
        devel@linuxdriverproject.org, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: bcm: fix checkpatch.pl errors and warnings
 in Version.h
Message-ID: <20120222112144.GC2491@localhost>
References: <4f428dfc.e302440a.02ba.6747@mx.google.com>
 <20120220183109.GL2855@mwanda>
 <CANz8tm3t5HM9QeNk+h4gNtbTs2UUW1qOe0t=TgnuSD3_gw_A7Q@mail.gmail.com>
 <20120220190952.GN2912@mwanda>
 <CANz8tm16FvLjUbgPWTsiz5WTje-bRCEAE1eWx3=F48Lm66-Tyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANz8tm16FvLjUbgPWTsiz5WTje-bRCEAE1eWx3=F48Lm66-Tyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 01:10:06AM +0530, Pradheep Shrinivasan wrote:

> > Are you asking me if I'm going to NAK your patch?  No.  It's an
> > unfortunate thing.  Checkpatch.pl is going around telling people to
> > add bogus parenthesis everywhere, and no one likes to redo their
> > patches.  And I feel like a jerk for telling people that they should
> > redo their patches.  And checkpatch.pl is a robot which has more
> > energy than I do.

In theory the number of things it gets right outweigh the things it gets
wrong and you do save energy overall.

I will poke checkpatch to try and stop it getting these wrong.

-apw
