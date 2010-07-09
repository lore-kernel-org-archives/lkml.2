Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0GIGQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:16:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33566 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab0GIGQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:16:34 -0400
Date: Fri, 9 Jul 2010 16:16:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Message-Id: <20100709161624.b27e8d7a.sfr@canb.auug.org.au>
In-Reply-To: <ada4og9z5a1.fsf@roland-alpha.cisco.com>
References: <20100709110427.c05987cc.sfr@canb.auug.org.au>
	<ada4og9z5a1.fsf@roland-alpha.cisco.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Jul_2010_16_16_24_+1000_J1rS3=IKGkE6njG0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Jul_2010_16_16_24_+1000_J1rS3=IKGkE6njG0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Thu, 08 Jul 2010 20:46:14 -0700 Roland Dreier <rdreier@cisco.com> wrote:
>
> Sorry, I took the version of the patch that Ralph sent me, instead of
> Ben's original patch, and that version dropped the most important part,
> namely the actual firmware file.
>=20
> Should be fixed now.

Thanks, I will pick it up on Monday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Jul_2010_16_16_24_+1000_J1rS3=IKGkE6njG0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMNr64AAoJEDMEi1NhKgbsexoH/2e0BHRDfkmdXhRIYzvLgKsA
Zja31i9ykgsama7ifF213YwY0z288aMxtbdKgt02tFhLgXk9r7KTkryUUfCia9OB
q6eybv+3iF4t1WHFhrJSQu3zA6tcndG8cW1gpXd3j6eqqI1QvgZs+zbff9yFw+nx
ztZd0dqeKUq8qfIfC3xmGD0FR/9SEOKuBdsImevs+HYcizyN782yDN1posKE3hzq
8cEKz5kOlaBXDfcBm/PQhNvdzv4yD/xjEm98Pm/W8NhGXt5WHrFI4lj8/AujiIm2
j62nwIBYD1oR7ncpmpgVCp6jjCp77mWfiT7Ibi0/NY7NTi0DBPe1d49bFfCmzwo=
=DMu9
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Jul_2010_16_16_24_+1000_J1rS3=IKGkE6njG0--
