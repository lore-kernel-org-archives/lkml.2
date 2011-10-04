Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1JDMvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:51:39 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:33366 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1JDMvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:51:38 -0400
Date: Tue, 4 Oct 2011 14:51:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111004125134.GB2803@osiris.boeblingen.de.ibm.com>
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
> 
> (if the old key would have been compromised, the attacker could as well 
> generate a new key and sign it with the old key himself, so I fail to see 
> any benefit of this PGP excercise).
> 
> It doesn't make too much sense to force people to live with two different 
> personalities in this "PGP web of trust" world just for the sake of 
> kernel.org, does it?

Also same question here. And as far as I can tell nobody has given an
answer yet.
