Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab1LWVJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:09:39 -0500
Received: from home.keithp.com ([63.227.221.253]:37974 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab1LWVJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:09:37 -0500
From: Keith Packard <keithp@keithp.com>
To: Eugeni Dodonov <eugeni@dodonov.net>
Cc: Udo Steinberg <udo@hypervisor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
In-Reply-To: <CAC7Lmnu7=7Y0K6zfmFsv_yPk_XAujNw6+D_B5vzpqhcQb27yhg@mail.gmail.com>
References: <20111221195410.5e4c065a@x220.fritz.box> <864nwty9sq.fsf@sumi.keithp.com> <20111221222626.0b8c3a30@x220.fritz.box> <861urxy1pw.fsf@sumi.keithp.com> <20111222014520.7ace1ab2@x220.fritz.box> <86y5u4wnhc.fsf@sumi.keithp.com> <CAC7Lmnu7=7Y0K6zfmFsv_yPk_XAujNw6+D_B5vzpqhcQb27yhg@mail.gmail.com>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 23 Dec 2011 13:10:47 -0800
Message-ID: <86pqffngdk.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Dec 2011 09:55:34 -0200, Eugeni Dodonov <eugeni@dodonov.net> wro=
te:

> Could we revert it for SNB, and leave it enabled for IVB?

Yes, that's my plan. I don't want to ever disable it for IVB.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvTuVzYtFsjWk68qAQgedxAAhrfpnsmq8lyw+4jfgrEc6o/fIWwbqZgX
Thdtp4uO8ntFPqvUTpEsYbMFX4SZJK8xGqzSuzJa4QHPXmiIuJr89RlSlelsGw36
oCx2uVnQSkwG/quDmuAmP7oBAXZujFG0ed+XqNYMKpZHCh3rbWuoMrSJ6DJ1D7Qw
sbMMxjIiHQo66BkNXEY9jgNuznd8aJ91CgYvBCPErrOgE4CSKJaArwbncwjxNIWC
5HD3aXlHfxS90b0efGhQ/z6GBuyLx7lFLIHOkccsY34Rj33DRYQAU6DNafXZ3WpH
gYHWIjYzZg+Gfbso7VZVHvE5xoNzfxpi6Bu1BoVTRjUq2TLCcGy17edBflAZubs3
lVS7BunItsG7jNGXk4qkVoed88HHnony2psxaAPohjAZMmwgXz5yO3zxXM2e9lpo
OOXLXfAJaEkbAjFJuNQH0lmtJThbpNPREBXdpNl5dVYjfvyIetCpzKWjuv2S9mHD
AWgYGa6KbD3ItAfvqknDFgG9lWU+pwed5BxHSorlLsrd8T5HQxxUEWXFPLk8wP9z
vncwTTTgmvD3F5oTRjix4oTjnbWIfPZKlmciWeeg6cTnYE8BtNmoLqmrRVOqgLYf
ZFucyCB0XC8zldmjHvjOHrl2fSOxL2/SJWWpDRo5JX/Czv8DvCo8GrD6SCIiCPSg
HZHwY+rN6QE=
=zROm
-----END PGP SIGNATURE-----
--=-=-=--
