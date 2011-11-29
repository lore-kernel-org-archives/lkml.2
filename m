Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1K2VYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:24:50 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:38719 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1K2VYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:24:49 -0500
Date: Tue, 29 Nov 2011 22:24:24 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MCE/Package power limit notification
Message-ID: <20111129222424.498469fe@x220.fritz.box>
In-Reply-To: <493994B35A117E4F832F97C4719C4C04022D835792@orsmsx505.amr.corp.intel.com>
References: <20111123160950.67860131@x220>
	<987664A83D2D224EAE907B061CE93D53027D89B577@orsmsx505.amr.corp.intel.com>
	<493994B35A117E4F832F97C4719C4C04022D835792@orsmsx505.amr.corp.intel.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bdMKFzN1vlUQMfkcD9fO89C"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bdMKFzN1vlUQMfkcD9fO89C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Nov 2011 14:50:47 -0800 Yu, Fenghua (YF) wrote:

YF> I sent out a patch to remove the mcelog info. Could you try it and see =
if it works for you?
YF> https://lkml.org/lkml/2011/11/14/239
YF>=20
YF> Thanks.
YF>=20
YF> -Fenghua

Hi Fenghua,

Thanks for the patch. It works and eliminates the MCE warnings. What exactly
are the BIOS issues mentioned in the patch description? Is BIOS programming
some MSRs the wrong way?

Cheers,

	- Udo

--Sig_/bdMKFzN1vlUQMfkcD9fO89C
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7VTYgACgkQnhRzXSM7nSlMPQCeOnIm/1O2pqVBeN0GSPLQHXf1
5SUAnjVBM6MU36DfNU77LhhDnxE2pD24
=BXpU
-----END PGP SIGNATURE-----

--Sig_/bdMKFzN1vlUQMfkcD9fO89C--
