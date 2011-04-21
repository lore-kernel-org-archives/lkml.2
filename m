Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1DUVun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:50:43 -0400
Received: from home.keithp.com ([63.227.221.253]:33750 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1DUVul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:50:41 -0400
From: Keith Packard <keithp@keithp.com>
To: Vinicius Gomes <vinicius.gomes@openbossa.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <BANLkTinK-cA67X6Knp-h5SKpjpDpwaMgZg@mail.gmail.com>
References: <yun1v1fj024.fsf@aiko.keithp.com> <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6> <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6> <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper> <20110411173409.1567679c@lxorguk.ukuu.org.uk> <BANLkTinK-cA67X6Knp-h5SKpjpDpwaMgZg@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 21 Apr 2011 14:50:32 -0700
Message-ID: <yunaafjs28n.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Apr 2011 13:59:23 -0300, Vinicius Gomes <vinicius.gomes@openboss=
a.org> wrote:

> Will send a proper fix soon. Thanks all.

This is still broken in -rc4, I'd love to see a proper patch soon --
this will affect any machine with a bluetooth device.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNsKaoQp8BWwlsTdMRAjjkAJ9hXPl3Y8T50g/lH1+lPH7vx2IN8gCgjZfu
bpd9cnPnRLknM98dv2BfnRo=
=jXoa
-----END PGP SIGNATURE-----
--=-=-=--
