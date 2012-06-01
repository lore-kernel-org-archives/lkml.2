Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2FAIHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:07:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:49220 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab2FAIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="150304822"
Message-ID: <1338538244.2536.147.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Date: Fri, 01 Jun 2012 11:10:44 +0300
In-Reply-To: <4FC8768E.1010703@nod.at>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
	 <1337771191-95358-2-git-send-email-richard@nod.at>
	 <4FC85780.9070200@intel.com> <4FC8768E.1010703@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1aGzVSx0akuQn6/53Wvg"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1aGzVSx0akuQn6/53Wvg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-01 at 10:00 +0200, Richard Weinberger wrote:
> True. But why is this a problem?
> If we can recovers using a full scan after a power cut we are fine.

Does fastmap have zero power-cut tolerance by design?

--=20
Best Regards,
Artem Bityutskiy

--=-1aGzVSx0akuQn6/53Wvg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyHkEAAoJECmIfjd9wqK0WI0QAIrYeCHfXDxHEG5noB+47MUW
jlhh3vNF/Zrkj0oqWRQaIgBLYliUdka2/TEXtPARBdYkYhMp01owfdQT3gWcEji9
7ZjZe6xPFnHKBmrouS8SVtKgxAf5RPsExtDZ5SUTOrGf2GRRcVFLouYRpFqPFtqW
urI0yXVMSmqJ1JhW2TRsGfDmIisiFqxdsfmJ3bXVDBpwsoZFRq5UJkCC2ZrJEBLf
hY8/PnKvC0m1C+KASmq+nHYZYkrIM9JTY4q6R6P95FsGTkT7R7/BvT0nDULNS14x
/DbYxDb04ZwmGof1X47f3s1n1TDVi51Y89RgxpmUibgwJFbligxKtvV7V5Jrs8OX
HRsoUQzs1RY/2Ocqb740m3gaj027lC5CsTcGSHMLI6De6yi5PKmO53o4mM3AxosW
BK1KOClqRHLvbSZtNc3Cp3YOFHUrDtpsbMQJgi/KQzOe79jRw3tdAnD8jlN0lN42
i6SV9Qxg85bS5j6T8+2aExpAYMsXXvv7OqpWoS2Jx5rmJqwI7edDaAtm0v7q7QhV
hOtMvsi54zTBcV8i9KHeQAx3Trs6Y6V7Ics+lc7GBv17I/uPaNANMqL06lU0epND
hwoWwPWZlQy5dHyKghvlBnH1K5rIdECGGmbftX0FaiMc+L1r8+uLt+9bo0zuf3mf
SpjQJ/SVdIf2OmtlGpfV
=Jq0x
-----END PGP SIGNATURE-----

--=-1aGzVSx0akuQn6/53Wvg--

