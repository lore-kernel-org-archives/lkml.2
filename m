Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2FTROh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:14:37 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46825 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2FTROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:14:35 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: next-20120620 build error in netfilter
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1340212473_2019P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Jun 2012 13:14:33 -0400
Message-ID: <32596.1340212473@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.52 mail-yw0-f52.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4FE204FA.014D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1340212473_2019P
Content-Type: text/plain; charset=us-ascii

Today's linux-next fails to build with CONFIG_NF_NAT_NEEDED=y and CONFIG_NF_NAT=m

  LD      init/built-in.o
net/built-in.o:(.data+0x4408): undefined reference to `nf_nat_tcp_seq_adjust'
make: *** [vmlinux] Error 1

Breakage introduced with this commit:

commit 8c88f87cb27ad09086940bdd3e6955e5325ec89a
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu Jun 7 13:31:25 2012 +0200

    netfilter: nfnetlink_queue: add NAT TCP sequence adjustment if packet mangled


--==_Exmh_1340212473_2019P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT+IE+AdmEQWDXROgAQJdNA/+N50BjqMLNgcxiBH2K1cSC2Si6ijADt6E
DSEcYM6hHzgpEpJ/kN9vEOWvgHsyKKNQ3cJTmy3sxFquFTL32miRjEYSMZ0GD/Sv
eEKRCPWdBi2iH5vVXVrRaLMe0qk6utK81KWfLXt15h/IWyyCGpWdkaO389NZk7U/
Wy42qySOOSGItX2VPTnYlSgk7418rhaaf4/Gw/C1c1V08yeQbxcqonPxkpANhl7w
UW/BG03OrkW0kDrEEvPTLnNLCrBNjUHcHLSL19mYVM8H3QQZm12/iTXh1BK9Evw9
McSmCrAqS+O9l91sjrUJu+zCrbZYqaIUGCWhIhJi6teV/+17WPuivH5imfTn1LiV
ZtfF2kU4TzDmmSRkvwWvxLYzBzoGnMRtEoxX61kpo+HD8YCFl2Sv4cYsOBBh++I5
NYSSVTHzgr3saj198QtcwShBAYYV95Qj3i8EMgzRt2gjker5OmIA1Ilexo5TOpPW
XLUv8Nl5lutbl37o9NWGiRFqp4IpSgC1KLSmxI48TC5CVAieztoU8Az+4aEo93UY
GS28hPEUGJTs2vdJbl28PGHqjfYc6rzsBIikHSRRMUltZeOtYnmzeiCO9TyxqjMH
znNwx+vwa8pE7MBA8k8anb2Lr+nnmx/CmBtrhLk8/tapS4aCg1D4EDZQ4qldrJ6m
d+IRtF0qEJU=
=jIRo
-----END PGP SIGNATURE-----

--==_Exmh_1340212473_2019P--

