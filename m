Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1HZVhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:37:31 -0400
Received: from gold.linx.net ([195.66.232.40]:48287 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab1HZVh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:37:28 -0400
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
From: Tony Vroon <tony@linx.net>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, yinghai@kernel.org
In-Reply-To: <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
References: <4E579397.6010009@linx.net>  <4E57CBBB.3040806@zytor.com>
	 <1314385315.8356.0.camel@localhost>
	 <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ztagixCyvfIfjNZxTQVT"
Organization: London Internet Exchange (AS5459; LINX)
Date: Fri, 26 Aug 2011 22:39:25 +0100
Message-ID: <1314394765.8356.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ztagixCyvfIfjNZxTQVT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-08-26 at 14:29 -0700, Suresh Siddha wrote:
> And you seem to say, things were _little_ bit better by using a MTRR
> script. What do you mean by _little_ ?

Little in that scrolling in terminals seems to work better. A failure
mode where the mouse cursor refuses to move seems to occur less often.

> Do you still see the original issue of hangcheck timer elapsed and it
> is just that the MTRR warning from drm driver disappeared with your
> MTRR script?

Yes, the hangcheck timer checks still fire intermittently and graphics
performance is still hit & miss. There is a failure mode that I call the
Amiga loading screen where vertical lines appear that are all a pixel
wide and are continuously changing in colour.

The AGP aperture is exactly 256MB in the location that the DRM warning
complained about, so what I did with the script was an attempt to answer
its lament. It accept that it may be completely meaningless in practice.

Regards,
Tony V.

--=-ztagixCyvfIfjNZxTQVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk5YEowACgkQp5vW4rUFj5qnoACeI/+nQ6Ivyo+LXxvP5+cWHjmq
gwoAoKiQCFdozoiBtza0vQGE/qs0ioyM
=fN9j
-----END PGP SIGNATURE-----

--=-ztagixCyvfIfjNZxTQVT--

