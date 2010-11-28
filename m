Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0K1Tql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:46:41 -0500
Received: from thunk.org ([69.25.196.29]:56438 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0K1Tqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:46:38 -0500
Date: Sun, 28 Nov 2010 14:46:24 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Microcai <microcai@fedoraproject.org>
Cc: Lisa Milne <lisa@ltmnet.com>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101128194624.GP2767@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Microcai <microcai@fedoraproject.org>, Lisa Milne <lisa@ltmnet.com>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1290941875.13526.15.camel@cai.gentoo>
 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
 <1290951770.13526.18.camel@cai.gentoo>
 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
 <20101129020610.7ea7c79e.lisa@ltmnet.com>
 <1290961207.13526.31.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290961207.13526.31.camel@cai.gentoo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:20:07AM +0800, Microcai wrote:
> 
> > Another possible model: split the current system in 2, so there's a
> > bytestream handler, and a vt-legacy module. Then use the interface
> > between bytestream/legacy as an interface for future vt-kernel and
> > vt-user modules.
> 
> this may cause early printk stop working. 

Let's start by asking a much more fundamental question; what the heck
are your goals?

If the main goal of the console is emergency debugging when the system
is in a very bad state (i.e., trashed initrd, etc.) do we really even
need Unicode support?

How many people do regular login, development, reading e-mail, etc.,
on the console?  Very few!  If the answer is because you hate X, as
you've already pointed out, we already have fbterm.  Where is it
written that we need to have a full unicode-capable console system?
Why is this so important; especially if doing this is going to be very
difficult, and risks breaking lots of stuff if we try to mess with it?

	       	     	      	      - Ted
