Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1KFWfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:35:19 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42881 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1KFWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:35:17 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: John Stoffel <john@stoffel.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
In-Reply-To: Your message of "Fri, 28 Oct 2011 16:52:28 EDT."
             <20139.5644.583790.903531@quad.stoffel.home>
From: Valdis.Kletnieks@vt.edu
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default> <75efb251-7a5e-4aca-91e2-f85627090363@default> <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy> <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com> <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default> <CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com> <20111028163053.GC1319@redhat.com> <3982e04f-8607-4f0a-b855-2e7f31aaa6f7@default>
            <20139.5644.583790.903531@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1320618774_135101P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 06 Nov 2011 17:32:54 -0500
Message-ID: <201529.1320618774@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4EB70B22.006B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1320618774_135101P
Content-Type: text/plain; charset=us-ascii

On Fri, 28 Oct 2011 16:52:28 EDT, John Stoffel said:
> Dan> "WHY" this is such a good idea is the same as WHY it is useful to
> Dan> add RAM to your systems. 
>
> So why would I use this instead of increasing the physical RAM?

You're welcome to buy me a new laptop that has a third DIMM slot. :)

There's a lot of people running hardware that already has the max amount of
supported RAM, and who for budget or legacy-support reasons can't easily do a
forklift upgrade to a new machine.

> if I've got a large system which cannot physically use any more
> memory, then it might be worth my while to use TMEM to get more
> performance out of this expensive hardware.

It's not always a large system....

--==_Exmh_1320618774_135101P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOtwsWcC3lWbTT17ARAlvfAKCoKX68t1pDd8M1xDoZuSpVYUljjACfRYID
7BmJgF1WCyqaQVF50mbeXUg=
=pNIL
-----END PGP SIGNATURE-----

--==_Exmh_1320618774_135101P--

