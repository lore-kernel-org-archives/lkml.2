Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1HZAjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:39:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49027 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1HZAjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:39:42 -0400
Date: Fri, 26 Aug 2011 10:39:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Timur Tabi <timur@freescale.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20110826103932.1626f1c5542b660bcd1b24aa@canb.auug.org.au>
In-Reply-To: <CACqU3MUs_97=MuuKAjr-LeUT7kSRxtzSntwUeKeeH4n8s7SSGg@mail.gmail.com>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
	<20110825140820.GA9126@kroah.com>
	<4E56689D.3080202@freescale.com>
	<20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
	<CACqU3MUs_97=MuuKAjr-LeUT7kSRxtzSntwUeKeeH4n8s7SSGg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_10_39_32_+1000_UQfyvCYc3R3Zechk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_10_39_32_+1000_UQfyvCYc3R3Zechk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnaud,

On Thu, 25 Aug 2011 12:09:20 -0400 Arnaud Lacombe <lacombar@gmail.com> wrot=
e:
>
> If you could provide an exhaustive list of them, I'd be interested. Do
> you account/reference them in the report you make on each new -next
> tree ?

I don't refer to them at all :-(

If you are not just referring to powerpc ones, then an x86_64
allmodconfig is a good place to start, there are several in there.

Otherwise, I will send you the results of some of my builds this evening.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_10_39_32_+1000_UQfyvCYc3R3Zechk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVutEAAoJEDMEi1NhKgbstWUH/2xvvQhPrYnpIAFED1Sk616Q
MffZWwjA3EpcxIYBQcyEVkLeymFZG3zcEpPo6dyEoiV1h8c1TCjQkFt2ACFPnbjj
H49835CYAzc9Yl6M2K8FM5XdkBgVXRbIA4J+Bd+aUddYYewNhju2Etk2leGEnzH/
KvAXoCgl8sPh1Q93QCeML7EbgFPpuK175d9k7Ckid4ihfoVPazA1kOTsQLVADroH
NC0pLcs0H69p4RDU4I6kEFNfEHIU1c+YyoVm3hebw7hLWe8UeS6ipTTLGWmg3ARo
tWxLPHFmKV29gVzvYNwPVNsaYivaDq389qk8Nd6L3Ju5wBxYNgR1O31fircJOoo=
=qvYM
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_10_39_32_+1000_UQfyvCYc3R3Zechk--
