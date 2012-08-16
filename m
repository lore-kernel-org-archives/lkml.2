Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2HPDMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:12:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43431 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2HPDMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:12:49 -0400
Date: Thu, 16 Aug 2012 13:12:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20120816131236.13013e1ec18b1f1074f6dc92@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_13_12_36_+1000_QSRTAGvVGfisfhjZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_13_12_36_+1000_QSRTAGvVGfisfhjZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/infiniband/hw/ehca/ehca_irq.c: In function 'find_next_online_cpu':
drivers/infiniband/hw/ehca/ehca_irq.c:672:2: error: expected ';' before 'sp=
in_unlock_irqrestore'

Caused by commit 81942621bd6b ("infiniband: Ehca: Use hotplug thread
infrastructure").

I have used the tip tree from next-20120814 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Aug_2012_13_12_36_+1000_QSRTAGvVGfisfhjZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLGUkAAoJEECxmPOUX5FE3FIP/3f3ZzQQ6+Jhct760KatyUUp
kM5nhuoSy0XPqtQ+YSK3GWS1CyAPHyewb09huAHuOstVvKdfwLCp+J9BzMaEU0lI
/BZRDH5dghbIMulu1Uo3w/6YU62HaHRaZ+auPXrYt072DEa7WJzYYiJTq2NnDl90
voBxC8f7ou/Kzyd6D3Ki/OuZdrTOZoGYbIN3iBKaZ24shj0hNCbgTsjuFg9+kRN7
UkENmXxDN7sV7fiMNrV98TdM6zk7s3QXgV8Rlq/7erIEcGSwOB+qqXMac5MmcsFH
31CJTUmI344751xsNO4Cw8/Gz4lvxsuD2nOVIvA98WF9inic/XgHmwAlKBKRlnoK
IgiTz/EDfTGoMjCzeZzi/vV79gb2OqVsQbwu2pFwUoAxlqoeh2rVb4g1v+ZTZ5Bz
vflg+D5EP7wUmFFejOHmpqOA++UBij24joCZyabc3EZR2HbN+ntLWiMdSMsKvrBx
wEtSEMsavFEePBxkzkuPz+vHcAz3xgroDLpPMzBxSldx9JCifxOZ7hBVb+C5EZ5r
faIeJ01GHgCRhQ927dhG2c/qt6WcNRG4YFd7vFgj3kQWwmAWOjyIbKI0Pr22cQ/f
dcPEzMuGLAqb9APpsV3cZ+1ULZ+2UiNesEUELd9SUTYK8Yyc3KUW1kWNdG53MxgC
t6xlQy96rgu1YiMKWxmN
=TXia
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_13_12_36_+1000_QSRTAGvVGfisfhjZ--
