Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1JEEiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:38:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47599 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1JEEiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:38:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Tue, 04 Oct 2011 19:17:30 EDT."
             <20111004231730.GB17089@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <20111004223932.GA3460@localhost.pp.htv.fi>
            <20111004231730.GB17089@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317789438_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Oct 2011 00:37:18 -0400
Message-ID: <13232.1317789438@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E8BDF02.0031,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317789438_4646P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Oct 2011 19:17:30 EDT, "Frank Ch. Eigler" said:

> But that's begging the question.  The semantics are what you want them
> to be.  Some keysigning parties take this super seriously, and maybe
> with strangers there's some room for this.  But in the end, when *I*
> see a key with someone else's signature on it, there is no proof how
> rigorously they investigated the person.  The "reliable identity" part
> of the web of trust is only one hop deep.

And in fact, there's even support for dealing with bozos who sign keys
incorrectly:

http://www.gnupg.org/gph/en/manual.html#AEN346

"trust in a key's owner" - one of the options is:

none - The owner is known to improperly sign other keys.

(I've done that for 3 people in Europe when I found their sigs on my key on the
keyservers, and they admitted in e-mail that they'd made no real attempt to
verify me...)

You can also assign "partial" or "full" trust, and then configure how many
partial and how many full trust sigs are needed to accept a key as "known".

--==_Exmh_1317789438_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOi97+cC3lWbTT17ARAm26AKCch3TpDnkJiqx8E+C9+iecswJwbQCfatgu
RRCFmcZRxy57ebUqBzlTVio=
=T4MG
-----END PGP SIGNATURE-----

--==_Exmh_1317789438_4646P--

