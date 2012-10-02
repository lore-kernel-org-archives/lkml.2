Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2JBEew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:34:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39701 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2JBEd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:33:59 -0400
Date: Tue, 2 Oct 2012 14:33:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Subject: linux-next: build failure after merge of the xen-two tree
Message-Id: <20121002143350.0fc9812c8ace3bd986ee7d34@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_14_33_50_+1000_micA0leKeScAbAre"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_14_33_50_+1000_micA0leKeScAbAre
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the xen-two tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/built-in.o: In function `xen_start_kernel':
(.init.text+0xa88): undefined reference to `xen_acpi_notify_hypervisor_stat=
e'
drivers/built-in.o: In function `dbgp_reset_prep':
(.text+0x12ddeb): undefined reference to `xen_dbgp_reset_prep'
drivers/built-in.o: In function `dbgp_external_startup':
(.text+0x12e6a9): undefined reference to `xen_dbgp_external_startup'

I have used the xen-two tree from next-20121001 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Oct_2012_14_33_50_+1000_micA0leKeScAbAre
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQam6uAAoJEECxmPOUX5FEAQsP/1ucAy3YMQCb6yYkbVKChhOk
5fEkHtcS/hnmf5Chv4lrKstgdE9mxk8d4Qo+0GsclBTV6vzZlPnq9ScXePQiAa/4
nEJYlLN3gGbXxJw/ljNRSFJIZ9rpiBMSmjnDNzQAZ0AjAs8c7aGFc2ImhtfjehkY
tc46MyjDvslcyMklGEEx5+6MaeKzgmUF0Ci3sJRYu5iBfDEGgvWqW5HMLazrtqET
WBLUyBDht80UGhW8c7BUjPrRT4AuxSyoTpnsFlzjQtPkkhimocRL9qk40BiJu0rI
OhVow0H9WZ63Kfc7Wxc7CmcOhjvky7htGBEh9qUjSuaw4x5XQWdpoAMHuETv26T5
Ftycd7R7tPLzwQzjb68r81exIXLnM8qj6t2tStDq8/clDbrhehhHL1+KYKvoWul9
jPDO1L3M3n4uwtQGsTVhXk+2vWipQRGmCQER06c+YDd71OF1QyIuOeaigyABeL2j
Eht8zdwCeWSMyheQEKl/iYDomaI3e7knT3YTfrZyztuDFHPD+KscapGd4EEoxjmP
D9if1YURnBqsvzj6TWXBUWiYSEeDGxoXvuZt0+l13vdnn5cws6l2GQ5tOurdW4tO
d4ljx2uDogIynfQAyxlzBxgV5a/ASx3apiX3rE2xugCWkgzpBgiNPCgm/lndCyqi
IM5febp1LdKPhYMqznj+
=VO1T
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_14_33_50_+1000_micA0leKeScAbAre--
