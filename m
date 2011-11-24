Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1KXLGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:06:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36336 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1KXLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:06:32 -0500
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: LiuShuo <b35362@freescale.com>
Cc: Li Yang-R58472 <r58472@freescale.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Nov 2011 13:07:13 +0200
In-Reply-To: <4ECE162D.7080408@freescale.com>
References: <1322095306-13156-1-git-send-email-b35362@freescale.com>
		 <1322095306-13156-3-git-send-email-b35362@freescale.com>
		 <1322120515.24797.296.camel@sauron.fi.intel.com>
		 <3F607A5180246847A760FD34122A1E052DC61F@039-SN1MPN1-003.039d.mgd.msft.net>
	 <1322122592.24797.299.camel@sauron.fi.intel.com>
	 <4ECE162D.7080408@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QMGEMjzdNHkByEM8QSYD"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1322132839.24797.301.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QMGEMjzdNHkByEM8QSYD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-11-24 at 18:02 +0800, LiuShuo wrote:
> =E4=BA=8E 2011=E5=B9=B411=E6=9C=8824=E6=97=A5 16:16, Artem Bityutskiy =E5=
=86=99=E9=81=93:
> > On Thu, 2011-11-24 at 07:49 +0000, Li Yang-R58472 wrote:
> >>> Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to s=
upport
> >>> large-page Nand chip
> >>>
> >>> On Thu, 2011-11-24 at 08:41 +0800, b35362@freescale.com wrote:
> >>>> +               /*
> >>>> +                * Freescale FCM controller has a 2K size limitation=
 of buffer
> >>>> +                * RAM, so elbc_fcm_ctrl->buffer have to be used if =
writesize
> >>>> +                * of chip is greater than 2048.
> >>>> +                * We malloc a large enough buffer (maximum page siz=
e is
> >>> 16K).
> >>>> +                */
> >>>> +               elbc_fcm_ctrl->buffer =3D kmalloc(1024 * 16 + 1024,
> >>> GFP_KERNEL);
> >>>
> >>> Are there NANDs with 16KiB page size?
> >> We are not sure, but are there possibility that chip with 16K page wil=
l appear?  Or maybe we can add a MACRO for the maximum page size?
> > I do not know, but I know that allocating 32KiB of contiguous physical
> > RAM may cause unneeded memory pressure and even fail if the memory is
> > too fragmented. So I would not go for this unless this is necessary.
> What is your suggestion ? 8k is enough ?

Up to you, I do not have suggestions, just expressed a concern. I'd keep
the buffer smaller if possible. By the time 16KiB pages appear, your HW
may retire already :-)

--=20
Best Regards,
Artem Bityutskiy

--=-QMGEMjzdNHkByEM8QSYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOziVhAAoJECmIfjd9wqK0dUUQAJXvsAdOTgo3ewdN8MExeQ6q
P6E8WMMcX+8RgPCAbnQjeGPYvKCdNq3bG0bWANrxBjOk5DoTePz+4C1DriIVFT3X
WjL64fULmfDRAk/4yNx/J1+J8X3fEdI4GwSWnWeOCzZpm+9SWJaePj/2e5RpAbET
AYRX22G/2Eh8kd89Vje3KYOtTBdaNgnQiOss1Tudr6qRaDrJENXlixSnqjnaInB/
zEIDKc/tzgra/suVC8vIFhaoikYHycL0MSa59sXHU8hGcDz6j5iCjbiJC0jgMb7V
4FOg4CxmpD9RonX2qydUQzfJXTHAC04zfOpkbv62Gc0fCYpcfhoqfrTaulL0+Rx+
mlMqob7Dz2v24yul7muE9AL+WcwVTAf6Anx/RwIPGGN6I9NipfeCLQhs0BkUE8U/
OylPpQ98BB5hmXzksSsG6PA7DGlF0xkUEZn5qCCDrFPUy5vhWeVS6suat6lyqG6Z
WbNxUtBrExvlNh/5fWV3av0oz53wt+MQlqw4mJEopQTS0An+Dvw+Zc5y2dizl41M
sJy1k5KE6g/F6zijsnzJLxRThOXsrl0AtviiZx7jirrbTW2US0Vw5L6goDxFbBUf
1LmuslsdbMA2IqGiig52MGjGzoo7bks23Z+XwwyhagwleEHvSvo/2h5n4SJUWhN7
eymrbGr9JfHjj5cM45Hs
=+v3x
-----END PGP SIGNATURE-----

--=-QMGEMjzdNHkByEM8QSYD--

