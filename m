Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1KRDW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:22:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46306 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1KRDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:22:57 -0500
Date: Fri, 18 Nov 2011 14:22:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Rong Wang <Rong.Wang@csr.com>
Subject: linux-next: manual merge of the tty tree with the mips tree
Message-Id: <20111118142245.5f4156be67f6048f58595b0d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Nov_2011_14_22_45_+1100_Cw8v4Odxe5zIsBo7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Nov_2011_14_22_45_+1100_Cw8v4Odxe5zIsBo7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/Makefile between commit 58235d376b15 ("SERIAL: AR933X:
Add driver for the built-in UART of the SoC") from the mips tree and
commit 161e773cbd0c ("UART: add CSR SiRFprimaII SoC on-chip uart
drivers") from the tty tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/Makefile
index 62f7d28,af57089..0000000
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@@ -89,4 -94,4 +89,5 @@@ obj-$(CONFIG_SERIAL_MSM_SMD)	+=3D msm_smd
  obj-$(CONFIG_SERIAL_MXS_AUART) +=3D mxs-auart.o
  obj-$(CONFIG_SERIAL_LANTIQ)	+=3D lantiq.o
  obj-$(CONFIG_SERIAL_XILINX_PS_UART) +=3D xilinx_uartps.o
 +obj-$(CONFIG_SERIAL_AR933X)   +=3D ar933x_uart.o
+ obj-$(CONFIG_SERIAL_SIRFSOC) +=3D sirfsoc_uart.o

--Signature=_Fri__18_Nov_2011_14_22_45_+1100_Cw8v4Odxe5zIsBo7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOxc+FAAoJEECxmPOUX5FEjsUP/3QnOG3efHgg13tl3OlaGjc8
3W2rT0ibZkOHemAPS69mbuyNrrzrZWvdgpX2EGwcu3Dtb1vo4hJiHF7USsEVOmn5
7+0Ecq8imUnC1CBMffgisQHtiPkW7RAUYpH+PIppal0o5dAwoHEpcgJEi4P0R4MD
979MAVlPZzu5Yx6hSI85SWWJd39KcbSC61tP0OP0RFbkKQTwTjCwhZ7EAlDskjE2
tMM/YHiD+AZUocd7INPgNfJBtDmkQeoYN6/xgOeMMKOcnk/i3hgqdL+394HkfNln
phKHlqA8ns3DhLFFjzco36xq5q7SmM56PIl8Up7eeB0wQN1I6BY04MmEWgxFvdge
ayyyA90blPY52Cz31SsBE5WS+gKqc1cbvXkvGg7/Sh7xvmB24FS2Qvseo7/7KisB
7NU+CmlZA70sP1hlZUmb2a8SLLSaVFJPNWwoOY0PFyQ160Z6R8AO99AbgBKwZXiX
CTW2zPTgtaqdqIYgtga8p+L1WfFNfGX0woP2Ooi3Crd013n0IJNfulofbUR4CTvY
Kd3bOadPwKRKrd+hjJ81z18R6p2O1RfJyHo7tW+KVDW74NfaMjQBbUooIVVb+HL6
b5125hvYShrVudyaYFSUei7y0ya+SKvnWD3BXYDs7sODHJx5hH5fcIkwm9pkHa2G
hfq8Qp49UmOr81Gxib/K
=aqtz
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Nov_2011_14_22_45_+1100_Cw8v4Odxe5zIsBo7--
