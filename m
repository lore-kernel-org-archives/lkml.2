Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0DONmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:42:07 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:56631 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0DONmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:42:05 -0400
Date: Thu, 15 Apr 2010 15:41:53 +0200
From: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default
 y
Message-ID: <20100415134152.GK21894@myhost.felk.cvut.cz>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20100413025228.GC10860@localhost.localdomain>
 <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
 <20100415063626.GG21894@myhost.felk.cvut.cz>
 <alpine.LRH.2.00.1004151233010.28179@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKy6e3LXpfmanBFM"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1004151233010.28179@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: o3FDfrcR022469
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.9,
	required 5, autolearn=not spam, BAYES_00 -1.90)
X-FELK-MailScanner-From: michal.svoboda@agents.felk.cvut.cz
X-FELK-MailScanner-To: linux-kernel@vger.kernel.org
X-FELK-MailScanner-Watermark: 1271943713.50438@cDWio5Uep7ainVFPCmKIfw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKy6e3LXpfmanBFM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jiri Kosina wrote:
> Access to /dev/mem being filtered in PAT obviously applies only to x86.=
=20
>=20
> Architectures which don't do such filtering in their respective=20
> phys_mem_access_prot_allowed() still need this option.

So why not use it for all archs uniformly? Is PAT filtering better in
some ways?=20


Michal Svoboda


--tKy6e3LXpfmanBFM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvHF6AACgkQg/fU9pp1uX50/QCgtaa1qdt9BhNtbEx1Oq3JbyCH
bVcAnjZcQTxz5ET4k4hE9wGs8vo6Umop
=x6CS
-----END PGP SIGNATURE-----

--tKy6e3LXpfmanBFM--
