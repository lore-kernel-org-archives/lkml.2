Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574Ab2EQWpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:45:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50255 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030537Ab2EQWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:45:04 -0400
Date: Fri, 18 May 2012 08:44:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, maxime.ripard@free-electrons.com,
        olof@lixom.net, linux-next@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20
 dtsi files
Message-Id: <20120518084446.a7b229074ea215fd7bcd1eb8@canb.auug.org.au>
In-Reply-To: <20120517150601.GA28104@kroah.com>
References: <4FB3B1F3.6080102@atmel.com>
	<1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com>
	<201205161850.54765.arnd@arndb.de>
	<20120517150601.GA28104@kroah.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_08_44_46_+1000_6msHVogyZVa8VPHC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_08_44_46_+1000_6msHVogyZVa8VPHC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 17 May 2012 08:06:01 -0700 Greg KH <gregkh@linuxfoundation.org> wro=
te:
>
> On Wed, May 16, 2012 at 06:50:54PM +0000, Arnd Bergmann wrote:
> > On Wednesday 16 May 2012, Nicolas Ferre wrote:
> > > Now that the bulk of at91sam9g20-related nodes are located in at91sam=
9260.dtsi,
> > > we have to re-create the path to this ADC node for SoC specific parts.
> > >=20
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >=20
> > Should we apply this patch in arm-soc so that Greg can drop the hunk th=
at
> > no longer applies?
>=20
> It's not a "no longer applies", it's a "this does not merge".  The patch
> is in my tree, unless you want me to revert it, it's going to stay there
> until it goes to Linus.

Just apply the patch to the arm-soc tree - then the merge resolution
becomes "use the arm-soc version".   There is no need for Greg to revert
the other patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_May_2012_08_44_46_+1000_6msHVogyZVa8VPHC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtX9eAAoJEECxmPOUX5FEZM8QAJMYiQ0ZOWnacah8/av2h8RI
UczJxyKOdJ1/QnhL2WxnQDNu51TFe+zhB5SXz/ZXj46BmXGWQUFL0s/6eWmWsWOd
o6HusFsJCbBs0RJQZ2M8wI6Y2kgBtxvT6y+YGJKt6lJmz6xeO3nkxHJImePvH2BX
T/QfidcpsuZQuTpAH/z5N40eUdGiwouqUSpNseLra4iSUrl1EQnDYUs8LBctqC0T
dPd/vHgOzbIfPu/+JSWtFHL2OihvixAHGFypshxRvRNHfmfHT5RTdsWnDW+odPUq
yfe8Qz+2aK/Xbn72DRQ9aznjrCFqsTWGcozGCRcAduCYGyFhVu0pNxMElQWqhs3U
YdtxOuaaR51vGoU+u9NUEGZghugQb7hw2PmGeeW7Ck22u53GV1Q1LrORw5/Q1rn1
1j9n6VzjSNliyWJkJenMwRiEehsx0+MffpBHhWOUxdGJ6mJZT2JkhcbYMpRKg7Hj
RdUV+DoihalVO3sbmqe3wqqJooTLqg91sExUHHFQuTOfcM0x6Rzz6Wm3/shAoQSY
cxyqATUfV8G+snnMNsprDvIAAH4/UdDM3zQlNeN2SszZF5ZcaBXbwdwPytJjrPcn
q6NZnurtEbL0R9VOddNju5KEiwyhe6s8F5stOpYw9esV6SA+IW0Fjz4WzE3wTOQ7
8rLnrjZRWbKul8eOyzX3
=0u6V
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_08_44_46_+1000_6msHVogyZVa8VPHC--
