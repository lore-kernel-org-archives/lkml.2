Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1JGRSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:18:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1JGRR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:17:58 -0400
Date: Fri, 7 Oct 2011 09:59:11 -0700
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jon Masters <jonathan@jonmasters.org>,
        Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111007165911.GA2022@suse.de>
References: <201110021354.57995.rjw@sisk.pl>
 <4E88A537.4010008@zytor.com>
 <20111003093239.GB25136@localhost.pp.htv.fi>
 <y0mobxyjazi.fsf@fche.csb>
 <20111003180441.GD3072@localhost.pp.htv.fi>
 <34045.1317760188@turing-police.cc.vt.edu>
 <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
 <14191.1317930659@turing-police.cc.vt.edu>
 <m34nzlbwbi.fsf@intrepid.localdomain>
 <15324.1318004954@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15324.1318004954@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 12:29:14PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Oct 2011 00:16:01 +0200, Krzysztof Halasa said:
> 
> > > Wouldn't the fact that I attend the keysigning party and claim that I was
> > > the owner of key B4D3D7B0, and then subsequently signing your key with
> > > that same key, prove that I actually controlled key B4D3D7B0?
> > 
> > I don't think it's needed. Alice claims ownership of key B4D3D7B0, gets
> > signatures on B4D3D7B0 public key. Bob (who actually controls B4D3D7B0)
> > reads Alice's mail and signs something "in Alice's name". Alice loses.
> 
> You got that 180 degrees out of phase.  Jon said he wanted a keysigning party
> where I would prove that I own key B4D3D7B0 (which is, in fact, my key) by
> signing something random. My claim is that if I can take Jon's key and sign it
> with B4D3D7B0, that's already proving I control the key, and another signing
> of something else doesn't prove anything regarding my control of the key.
> 
> Now mind you, it *does* have its uses - for example, "sign the random string
> I just e-mailed you" will verify that I have control of the e-mail address that the
> key claims to be attached to.  But that's different from proving I have control
> of the actual key.

If you are worried about this type of thing, then just use the tool
'caff' when signing keys, it handles all of this type of thing
automatically as well as making it very easy to sign keys.  I just found
it a few days ago and it's already saved me tons of time.

greg k-h
