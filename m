Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab1JFTvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:51:48 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54469 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183Ab1JFTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:51:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jon Masters <jonathan@jonmasters.org>
Cc: Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Thu, 06 Oct 2011 11:58:22 EDT."
             <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu>
            <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317930659_2653P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Oct 2011 15:50:59 -0400
Message-ID: <14191.1317930659@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E8E06A5.009B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317930659_2653P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Oct 2011 11:58:22 EDT, Jon Masters said:

> What I'd like to see is "keysigning" parties where folks with well
> established (in use) keys turn up and *prove* they own the key by
> signing some information the other attendees provide. That way they can
> not only say "hey, I'm dude X, trust me this is my fingerprint, here's a
> photo ID" (which means nothing in the case of a well established online
> identify that is trusted already), but they can say "hey, I have access
> to this key, because I just signed that random message you gave me
> interactively". 

Wouldn't the fact that I attend the keysigning party and claim that I was
the owner of key B4D3D7B0, and then subsequently signing your key with
that same key, prove that I actually controlled key B4D3D7B0?

The other possibility is that I was an impostor *and* that the real owner of
key B4D3D7B0 was coincidentally going around that same day and signing keys for
everybody at the keysigning without doing proper verification.  Which you have
to admit is rather a long shot...


--==_Exmh_1317930659_2653P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjgajcC3lWbTT17ARAhkBAKCU00OeQ6nK2AnVd43VGVka1nC5zgCggNd7
W1ovM65uo9//Qt/1yNUja3g=
=u9om
-----END PGP SIGNATURE-----

--==_Exmh_1317930659_2653P--

