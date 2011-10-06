Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935919Ab1JFWQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:16:05 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:51296 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935778Ab1JFWQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:16:03 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Valdis.Kletnieks@vt.edu
Cc: Jon Masters <jonathan@jonmasters.org>, Adrian Bunk <bunk@stusta.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: <14191.1317930659@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Thu, 06 Oct 2011 15:50:59 -0400")
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<1317916702.19519.1.camel@constitution.bos.jonmasters.org>
	<14191.1317930659@turing-police.cc.vt.edu>
Date: Fri, 07 Oct 2011 00:16:01 +0200
Message-ID: <m34nzlbwbi.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 06 Oct 2011 11:58:22 EDT, Jon Masters said:
>> What I'd like to see is "keysigning" parties where folks with well
>> established (in use) keys turn up and *prove* they own the key by
>> signing some information the other attendees provide. That way they can
>> not only say "hey, I'm dude X, trust me this is my fingerprint, here's a
>> photo ID" (which means nothing in the case of a well established online
>> identify that is trusted already),

The person may be trusted but how do you know the message apparently
from that person is genuine?

Valdis.Kletnieks@vt.edu writes:

> Wouldn't the fact that I attend the keysigning party and claim that I was
> the owner of key B4D3D7B0, and then subsequently signing your key with
> that same key, prove that I actually controlled key B4D3D7B0?

I don't think it's needed. Alice claims ownership of key B4D3D7B0, gets
signatures on B4D3D7B0 public key. Bob (who actually controls B4D3D7B0)
reads Alice's mail and signs something "in Alice's name". Alice loses.
There are many ways for Alice to lose if she wishes to. One of the
simpler ones is to send the private key straight to Chuck then erase it
from her computer.

It's Alice's problem to make sure other people sign her key instead of
some other number she has found on the floor. It's their responsibility
to verify Alice's identity, but they aren't responsible for her actions.
-- 
Krzysztof Halasa
