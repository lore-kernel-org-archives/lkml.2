Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab1JGQbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:31:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42099 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1JGQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:31:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jon Masters <jonathan@jonmasters.org>, Adrian Bunk <bunk@stusta.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Fri, 07 Oct 2011 00:16:01 +0200."
             <m34nzlbwbi.fsf@intrepid.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <1317916702.19519.1.camel@constitution.bos.jonmasters.org> <14191.1317930659@turing-police.cc.vt.edu>
            <m34nzlbwbi.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318004953_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 12:29:14 -0400
Message-ID: <15324.1318004954@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E8F28E1.00A8,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318004953_9306P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Oct 2011 00:16:01 +0200, Krzysztof Halasa said:

> > Wouldn't the fact that I attend the keysigning party and claim that I was
> > the owner of key B4D3D7B0, and then subsequently signing your key with
> > that same key, prove that I actually controlled key B4D3D7B0?
> 
> I don't think it's needed. Alice claims ownership of key B4D3D7B0, gets
> signatures on B4D3D7B0 public key. Bob (who actually controls B4D3D7B0)
> reads Alice's mail and signs something "in Alice's name". Alice loses.

You got that 180 degrees out of phase.  Jon said he wanted a keysigning party
where I would prove that I own key B4D3D7B0 (which is, in fact, my key) by
signing something random. My claim is that if I can take Jon's key and sign it
with B4D3D7B0, that's already proving I control the key, and another signing
of something else doesn't prove anything regarding my control of the key.

Now mind you, it *does* have its uses - for example, "sign the random string
I just e-mailed you" will verify that I have control of the e-mail address that the
key claims to be attached to.  But that's different from proving I have control
of the actual key.


--==_Exmh_1318004953_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjyjZcC3lWbTT17ARAgVQAJ4l7xue8SoXR6SIs0pF7clBZZP6HgCdF4WP
PaLF3MdikCqSc9/vCjDCBRc=
=5r3g
-----END PGP SIGNATURE-----

--==_Exmh_1318004953_9306P--

