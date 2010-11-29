Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0K2BMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:12:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56142 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0K2BMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=NIwistrmz+OxH1CF+t0x+i3pYSr23cYofz0K0re711rpY7ijJENn2MHj57ZsO7dsUJ
         UP9Vg5LXvfE3sYPiQwKBebdw1IPrskkrOIg5gQfjw329ZBjNj7KMiRjl+dTMwQR13+87
         TY//iojBCZAQT2ZVGtVRZbNuLFg9jDXCwg8fc=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Lisa Milne <lisa@ltmnet.com>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101128194624.GP2767@thunk.org>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
	 <1290961207.13526.31.camel@cai.gentoo>  <20101128194624.GP2767@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 09:14:04 +0800
Message-ID: <1290993244.877.3.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-28日的 14:46 -0500，Ted Ts'o写道：
> On Mon, Nov 29, 2010 at 12:20:07AM +0800, Microcai wrote:
> > 
> > > Another possible model: split the current system in 2, so there's a
> > > bytestream handler, and a vt-legacy module. Then use the interface
> > > between bytestream/legacy as an interface for future vt-kernel and
> > > vt-user modules.
> > 
> > this may cause early printk stop working. 
> 
> Let's start by asking a much more fundamental question; what the heck
> are your goals?
> 
> If the main goal of the console is emergency debugging when the system
> is in a very bad state (i.e., trashed initrd, etc.) do we really even
> need Unicode support?
> 
> How many people do regular login, development, reading e-mail, etc.,
> on the console?  Very few!  If the answer is because you hate X, as
> you've already pointed out, we already have fbterm.  Where is it
> written that we need to have a full unicode-capable console system?
> Why is this so important; especially if doing this is going to be very
> difficult, and risks breaking lots of stuff if we try to mess with it?
> 
> 	       	     	      	      - Ted

Hey, my old patch already did it , and do not break any old stuff.
Question is , the VT code *is really very old*. 
Just want to simplify the code, remove old stuff, make it future
compatible. Forward compatibility is more important than backward one  



