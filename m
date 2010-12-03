Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab0LCONg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:13:36 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56360 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755006Ab0LCONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:13:35 -0500
Date: Fri, 3 Dec 2010 15:13:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101203141324.GA2371@ucw.cz>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
 <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
 <20101121130236.GE23423@thunk.org>
 <20101121172906.GD3703@kroah.com>
 <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
 <20101121203124.1ba8212e@lxorguk.ukuu.org.uk>
 <20101121214407.GH23423@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121214407.GH23423@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Which we know in practice they won't. They'll sit on fixes (often
> > security fixes) and tweak and add private copies of features. In turn the
> > Linux one could then only keep up by adding features itself - which would
> > have to be GPL to stop the same abuse continuing.
> > 
> > It's a nice idea but the corporations exist to make money and adding
> > proprietary custom stack add-ons is clearly a good move on their part to
> > do that.
> 
> Hence my recommendation that if someone is going to do the work to
> create a 802.11 layer that has shims that work on multiple operating
> systems, it be GPL with explicit exceptions to allow said layer to
> work on legacy operating systems like QNX, et. al.  That way it forces

Is the exception even neccessary? GPL has explicit permission to link
against non-GPL 'system' and 'compiler' libraries --which seems to be
exactly this.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
