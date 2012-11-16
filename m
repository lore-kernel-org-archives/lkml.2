Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2KPLrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:47:07 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:39410 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab2KPLrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:47:06 -0500
Date: Fri, 16 Nov 2012 12:47:03 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel mlist <linux-kernel@vger.kernel.org>
Cc: nik@linuxbox.cz
Subject: strange values of loadavg and nr of io-blocked tasks
Message-ID: <20121116114703.GA8634@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 8074727 records (last update: 20121116)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I was doing some I/O tuning of our KVM host, and noticed some
strange behaviour. When I start some heavy I/O load on guest
(ie run some fio benchmark), loadavg value of the host jumps
to value about 65 and holds until load ends. sar reports similar
number of blocked tasks. I don't really understand those numbers,
because only active tasks are 4 qemu-kvm threads and few other sleeping
tasks (so none in R or D state).
is it possible to somehow find which tasks seem to be blocked?
or why is loadavg value so high?
the system is x86_64 quad core with 4GB RAM running centos 6 with 3.0.52-rc=
1 kernel.

Thanks a lot in advance for any answer

BR

nik

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlCmJ7cACgkQ3xdJJrLygV5BvgCfcKJAWOafvYw14qwrF/Dqa2gp
9N0An1hVO0yjcmaGa5C1J1UbK/6yflEK
=DzVH
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
