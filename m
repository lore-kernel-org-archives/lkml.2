Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2GNBb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 21:31:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57947 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GNBb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 21:31:56 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Piotr Sawuk" <a9702387@unet.univie.ac.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: resurrecting tcphealth
In-Reply-To: Your message of "Fri, 13 Jul 2012 16:55:44 -0700."
             <20120713165544.6767ea8f@nehalam.linuxnetplumber.net>
From: valdis.kletnieks@vt.edu
References: <e9caf38359467bfa8a1e2ac86f6ef2cc.squirrel@webmail.univie.ac.at>
            <20120713165544.6767ea8f@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1342229512_2294P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2012 21:31:52 -0400
Message-ID: <3436.1342229512@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.216.180 mail-qc0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.5000CC0B.0020,ss=1,re=0.000,fgs=0,
	ip=71.62.120.57,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1342229512_2294P
Content-Type: text/plain; charset=us-ascii

On Fri, 13 Jul 2012 16:55:44 -0700, Stephen Hemminger said:

> >+			/* Course retransmit inefficiency- this packet has been received twice. */
> >+			tp->dup_pkts_recv++;
>
> I don't understand that comment, could you use a better sentence please?

I think what was intended was:

/* Curse you, retransmit inefficiency! This packet has been received at least twice */

--==_Exmh_1342229512_2294P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUADMBwdmEQWDXROgAQJUqw/9HmNIPSdsQleef27JibtBPdrjpDEqYugB
TTgRHjWd2VTR4x6AP2OIqqSA/Fb4VWmo6t7jCuXK7fGkCVQ4ut9iA40NeTpcwUu/
Qt8lQxmzIXJjj9fotdW6djrg3MOo/w7DMa+86XoQJ+XmmSKR9HMSw0XHNco8D2+l
Q/SlDw53T0VTuK5V9sEddczAf83ZsOo/hbXXG/vlLcw+VNaM18l366ZGV7BDsHqk
EC6tQmjOuSY6I3zuOX9fVv7uOiQPgvGS0aGLmUuWSxLUDgSyisuIZbF0ha9+0FRe
/KQMOS4aW/ZEmnY7AtyqiViOtmrsSYL9pu4Ub4Nc8XFQZ8ONDBGQDHWUiUInxrzv
sYwNHBvSzzpD5fK3jMQBPAto/oFWoH2ImNl8zeLEkAHaUe0LHv2L+ylXlzsOwBg+
4kQi50eFZg1TjdnWUgI+Oo0CE9chSPh9eOEVzN3V0KKmCD4Ztv9XaiVxb/TqtyiX
8IWS0+dv9RSiiCyao/eK8eHBVTfHknLKoZAn+gp6aV6HYPr0W23UXyR0jBlpeXTm
IeJuShY6+cm4A15xhKzDnc9UodD9XU3D0rhbjilbSFBVaNjrcI8nroOZI1gWVRNx
RSSPeY9VbVtjLgVOAq0c9+HCNaiA+l6YGtbiCpn6IyDnBlEMUbt4OcnzK+/MYNy4
yV8ABGbq95k=
=e6fp
-----END PGP SIGNATURE-----

--==_Exmh_1342229512_2294P--

