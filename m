Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1JHPo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 11:44:27 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:40207 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab1JHPo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 11:44:26 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Valdis.Kletnieks@vt.edu, Adrian Bunk <bunk@stusta.de>,
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
	<1318050133.19519.184.camel@constitution.bos.jonmasters.org>
Date: Sat, 08 Oct 2011 17:44:23 +0200
In-Reply-To: <1318050133.19519.184.camel@constitution.bos.jonmasters.org> (Jon
	Masters's message of "Sat, 08 Oct 2011 01:02:13 -0400")
Message-ID: <m3ehynzdwo.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters <jonathan@jonmasters.org> writes:

> What I'm saying is that unless you sign something (random text, my
> actual key(s)) in my presence, I can't actually know it was you I was
> dealing with or someone else claiming to be you (or your identity).

Ahh, that's when the key is already signed, and when you can't see the
person in question. Sure. That's a normal ID check using the asymmetric
key pair.

> I see all these keysigning parties where people dutifully check IDs they
> don't really know how to recognize and am always struck by how the
> offline post-event nature effectively never proves the person you met in
> real life is the person whose key you just signed, just that some ID
> seemed to reasonably match the name on the fingerprint at the time.

There is nothing post-event in it. You are to collect (or check) the
fingerprint and check the ID. Post-event you only check the fingerprint
(against the authenticated fingerprint you collected at the party).
Assuming the fingerprint algorithm is secure (i.e. it's reasonably hard
to produce a collision) this process is safe.

> I
> bet it someone turned up at one of these events with a $100 fake ID made
> in China of the kind I hear about on the radio these days, a large
> majority of those present would happily sign a key claiming to match
> that ID after the event, even if the real owner was never there.

Yes. The signing party only proves a connection between a
reasonably-looking ID (and/or person) and a private key. It's very hard
to go any further, what would you use? A full genome check versus one's
parents? :-)

Of course it's much harder to impersonate someone who is well known.
That's also why a big international key signing party isn't the best
idea.
-- 
Krzysztof Halasa
