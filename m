Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab1JCW5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:57:10 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52065 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab1JCW47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:56:59 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Mon, 3 Oct 2011 15:56:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111003225651.GA10257@leaf>
References: <4E8655CD.90107@zytor.com>
 <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 01:19:27PM +0200, Jiri Kosina wrote:
> On Fri, 30 Sep 2011, H. Peter Anvin wrote:
> 
> > Since the kernel.org status announcement last week a number of you
> > have contacted me about re-establishing credentials.  In order to
> > establish a proper PGP web of trust we need keys that are cross-signed
> > by other developers.  As such, we ask that you follow the following
> > steps:
> > 
> > 1. Make sure your systems are uncompromised.  We will address specific
> >    recommended steps for that in a separate email.
> > 
> > 2. Create a new PGP/GPG key, and also generate a key revocation
> >    certificate (but don't import it anywhere -- save it for the
> >    future) for your new key.  In the near future we are considering
> >    setting up an escrow service for key revocation certificates.
> > 
> >    I recommend using a 4096-bit RSA key.  Given how fast computers are
> >    these days, there is no reason to use a shorter key.  DSA keys
> >    should be considered obsolete; substantial weaknesses have been
> >    found in DSA.
> > 
> >    $ gpg --gen-key
> >    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke
> > 
> > 3. If you are reasonably certain that your old key has never been
> >    jeopardized, sign the new key with the old key.
> 
> I have a question here. In case people are 'reasonably certain' that the 
> old key has never been jeoparadized, why are they required to create a new 
> key?
[...]
> It doesn't make too much sense to force people to live with two different 
> personalities in this "PGP web of trust" world just for the sake of 
> kernel.org, does it?

Same question here.  I have a key, which has already accumulated some
signatures, and I feel confident that key remains secure, along with the
one and only system that key lives on.  I have a revocation certificate
prepared for that key in a secure location, though I'd certainly welcome
an escrow service from kernel.org as long as that service only stored
encrypted documents to which only the key owner had the passphrase.  I
don't see any need to generate an entirely new key in a hurry.
Certainly transitioning to larger and algorithmically better keys over
time seems like a good idea, but given the nature of the kernel.org
compromise, immediate concerns about the strength of GPG keys seems much
less warranted than concerns about the security of the systems they live
on.

- Josh Triplett
