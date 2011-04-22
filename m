Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1DVAEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:04:55 -0400
Received: from home.keithp.com ([63.227.221.253]:33777 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab1DVAEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:04:54 -0400
From: Keith Packard <keithp@keithp.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Vinicius Gomes <vinicius.gomes@openbossa.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <20110421225953.GA2323@joana>
References: <yun1v1fj024.fsf@aiko.keithp.com> <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6> <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6> <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper> <20110411173409.1567679c@lxorguk.ukuu.org.uk> <BANLkTinK-cA67X6Knp-h5SKpjpDpwaMgZg@mail.gmail.com> <yunaafjs28n.fsf@aiko.keithp.com> <20110421225953.GA2323@joana>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 21 Apr 2011 17:04:51 -0700
Message-ID: <yun62q7i21o.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


On Thu, 21 Apr 2011 19:59:53 -0300, "Gustavo F. Padovan" <padovan@profusion=
.mobi> wrote:

> Patch is on the way to mainline. It's currently on wireless-2.6. Next ste=
ps
> are net-2.6 -> linux-2.6.

I didn't see it on linux-kernel, so I was a bit worried. I'd love to
test it in place of the kludge that Vinicius sent me.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNsMYjQp8BWwlsTdMRApX8AJ9vrnM4CArC56KHhQw2N3m7G6ohiwCfV0JO
MZoPFs2kv0eMHglCjQXwKBc=
=W13N
-----END PGP SIGNATURE-----
--=-=-=--
