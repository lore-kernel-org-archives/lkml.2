Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1JHPQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 11:16:13 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:60082 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1JHPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 11:16:12 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Valdis.Kletnieks@vt.edu
Cc: Jon Masters <jonathan@jonmasters.org>, Adrian Bunk <bunk@stusta.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<1317916702.19519.1.camel@constitution.bos.jonmasters.org>
	<14191.1317930659@turing-police.cc.vt.edu>
	<m34nzlbwbi.fsf@intrepid.localdomain>
	<15324.1318004954@turing-police.cc.vt.edu>
Date: Sat, 08 Oct 2011 17:16:09 +0200
In-Reply-To: <15324.1318004954@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Fri, 07 Oct 2011 12:29:14 -0400")
Message-ID: <m3ipnzzf7q.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> You got that 180 degrees out of phase.  Jon said he wanted a keysigning party
> where I would prove that I own key B4D3D7B0 (which is, in fact, my key) by
> signing something random.

But this is not needed at all. While signing someone's public key, you
don't need to check if he has a corresponding private key. That's BTW
the same as with PKI certificate requests.

By signing one's public key you don't certify at all that you know
anything about the corresponding private key. You certify that the
person in question confirmed this public key belongs to him/her. You may
want to check the email part, but it's part of the identity check, not
the private key check.

The check if someone has access to the private key is important later,
when we can't see the person.

> My claim is that if I can take Jon's key and sign it
> with B4D3D7B0, that's already proving I control the key, and another signing
> of something else doesn't prove anything regarding my control of the
> key.

That may be disputable but what I wanted to say is it simply doesn't
matter.

> Now mind you, it *does* have its uses - for example, "sign the random string
> I just e-mailed you" will verify that I have control of the e-mail address that the
> key claims to be attached to.  But that's different from proving I have control
> of the actual key.

Definitely.
-- 
Krzysztof Halasa
