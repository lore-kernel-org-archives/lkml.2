Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HLCM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:12:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35435 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1HLCMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:12:25 -0400
Date: Fri, 12 Aug 2011 12:12:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Greg KH <gregkh@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless & staging trees related)
Message-Id: <20110812121216.28e6979b44bacb651849640b@canb.auug.org.au>
In-Reply-To: <4E43FA61.1010301@qca.qualcomm.com>
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
	<4E438D56.5020801@qca.qualcomm.com>
	<20110811141604.GA14763@suse.de>
	<4E43FA61.1010301@qca.qualcomm.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_12_12_16_+1000_.tf0OjeicfexTwCo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Aug_2011_12_12_16_+1000_.tf0OjeicfexTwCo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kalle, Greg,

On Thu, 11 Aug 2011 18:50:57 +0300 Kalle Valo <kvalo@qca.qualcomm.com> wrot=
e:
>
> On 08/11/2011 05:16 PM, Greg KH wrote:
> > On Thu, Aug 11, 2011 at 11:05:42AM +0300, Kalle Valo wrote:
> >
> >> Yes, the cleaned up version of ath6kl is now in wireless-next and the
> >> staging version can be removed in 3.2. Greg, how do you want to handle
> >> removal of the staging version? Should I send a patch to you removing
> >> it? Or should I send the patch to John?
> >=20
> > Just tell me.  Should I really delete drivers/staging/ath6kl/ for the
> > 3.2 kernel release?  If so, I'll gladly do so in my tree so linux-next
> > will be fine for issues like this in the future.
>=20
> Yes, please delete ath6kl from staging for the 3.2 release as the
> cleanup version is now in wireless-next.
>=20
> Thank you everyone and sorry for the mess.

I think that the removal should be done in the wirelesss tree so that
Linus' tree is not broken during the next merge window.

I have added the removal patch as a merge fixup one the merge of the
wireless tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_12_12_16_+1000_.tf0OjeicfexTwCo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORIwAAAoJEDMEi1NhKgbs2zkIAIVADG9NBi1VOHru1G4RIo0/
Zt0AN9yRK8DAygx1IV1A7/rFJNEyK5KFvgf0azMcgE8Agksh+BUx+aTEIQmGLNR0
opa41ZSytP91SsqGmaKhxckSbPujqXbDpYNF69o+g93I54iCIw1QLXyR4fY9bKH/
1tHAYSJnQB2067gk505llDeD2fR7k0JcoQ64F87/yvAMGyy8bu9mSDUqagMf2gpM
+UhB4L5ZQn2hTLR75dEgxM5M14QKgOJaOONKl69kDUMdVkzBQIwVco7wWnpwtbl2
8nsg/VJ/TAm46uapjnn5okF4DotAoyYoPDnPY7zNQf+b6OXB5pt6GZvZicYpqMg=
=Qoe5
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_12_12_16_+1000_.tf0OjeicfexTwCo--
