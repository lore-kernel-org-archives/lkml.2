Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1JGSXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:23:46 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49115 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1JGSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:23:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jon Masters <jonathan@jonmasters.org>,
        Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Fri, 07 Oct 2011 12:59:30 EDT."
             <CACqU3MUhn-cb+Xg2GwR0qZNY18O3nsNsMRXs=zqE9quzr3VMGA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <1317916702.19519.1.camel@constitution.bos.jonmasters.org> <14191.1317930659@turing-police.cc.vt.edu> <m34nzlbwbi.fsf@intrepid.localdomain> <15324.1318004954@turing-police.cc.vt.edu>
            <CACqU3MUhn-cb+Xg2GwR0qZNY18O3nsNsMRXs=zqE9quzr3VMGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318011772_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 14:22:52 -0400
Message-ID: <19583.1318011772@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E8F4380.014D,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318011772_9306P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Oct 2011 12:59:30 EDT, Arnaud Lacombe said:

> How so ? The public key BOb has is mathematically tied to the private
> key Alice has. If Bob sends Alice a mail, and then, she send a reply
> signed with her key, which is tied to the mail address used by Bob.
> Then, Bob successfully verifies the signature. This proves Alice has
> control over the key tied and the mail address, don't it ? 

As I said - yes, that *DOES* prove control over key and email address.

The point is that signing something random does not prove anything about
control of the *KEY ONLY* that isn't also proved by using the key to sign
another key.


--==_Exmh_1318011772_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOj0N8cC3lWbTT17ARAuKZAKC/cWbOZZsm9g2jBFYE/kcjEZc0KQCfU5Qb
YqjvOgm89AGmanGuG1sj/ys=
=l6Db
-----END PGP SIGNATURE-----

--==_Exmh_1318011772_9306P--

