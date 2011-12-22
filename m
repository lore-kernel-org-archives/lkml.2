Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1LVPat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:30:49 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:47493 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab1LVPaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:30:46 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 10:30:45 EST
Date: Thu, 22 Dec 2011 16:19:08 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel mlist <linux-kernel@vger.kernel.org>
Cc: stable@kernel.org, netdev@vger.kernel.org
Subject: 3.0.12 - unregister_pernet_gen_subsys hogging whole system
Message-ID: <20111222151908.GA11020@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5919432 records (last update: 20111222)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after updating one of our servers to 3.0.12 kernel, it became painfully slo=
w (actually
it's almost unusable).

trying perf top, I see following:

            27465.00 - 59.8% : unregister_pernet_gen_subsys
             3144.00 -  6.8% : __start_notes
             1211.00 -  2.6% : swiotlb_sync_sg
             1155.00 -  2.5% : swiotlb_unmap_sg_attrs
              621.00 -  1.4% : pci_pm_init
              565.00 -  1.2% : swiotlb_map_sg_attrs
              503.00 -  1.1% : cgroup_attach_task

I wasn't too successfull trying to find something related, so I'd like to a=
sk,
which subsystem might be calling unregister_pernet_gen_subsys and why?
I guess this is certaingly a bug... Could somebody please have a look at th=
is?
I'll provide all debugging information I can if needed..

thanks a lot in advance

with best regards

nik

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7zSmwACgkQ3xdJJrLygV6OaACfc9yp//bLzKRyt6pqSkYJWaBU
mzIAmgOw9Wk1wwqLrTSGVHtnXEcqH8O6
=L4u3
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
