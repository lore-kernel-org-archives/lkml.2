Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2FTSiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:38:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48332 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2FTShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:37:55 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: next-20120620 build error in netfilter
In-Reply-To: Your message of "Wed, 20 Jun 2012 19:28:01 +0200."
             <20120620172801.GA9385@1984>
From: valdis.kletnieks@vt.edu
References: <32596.1340212473@turing-police.cc.vt.edu>
            <20120620172801.GA9385@1984>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1340217472_2019P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Jun 2012 14:37:52 -0400
Message-ID: <55558.1340217472@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.160.180 mail-gh0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4FE21883.0040,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1340217472_2019P
Content-Type: text/plain; charset=us-ascii

On Wed, 20 Jun 2012 19:28:01 +0200, Pablo Neira Ayuso said:
> On Wed, Jun 20, 2012 at 01:14:33PM -0400, Valdis Kletnieks wrote:
> > Today's linux-next fails to build with CONFIG_NF_NAT_NEEDED=y and CONFIG_NF_NAT=m
> >
> >   LD      init/built-in.o
> > net/built-in.o:(.data+0x4408): undefined reference to `nf_nat_tcp_seq_adjust'
> > make: *** [vmlinux] Error 1
>
> I guess you have NF_CT_NETLINK=y, right?

Yes.

Temporary workaround was setting NF_NAT=n (I don't use NAT, I just usually
build all the netfilter modules as =m even if I don't use them, just to provide
build coverage and trip over stuff like this).


--==_Exmh_1340217472_2019P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT+IYgAdmEQWDXROgAQIG+hAAnd4idYSLEklTd82AQOhDPhRvr4jA0c/K
IRQGXnRDKD6IUDtCfexbACThnal6Hn6txdUXOGEEGyD//VG4lBhBMEyhjZ1kfhBN
gyjYXvS85DmuQAxJyevfeWzPAPGhzThav84pgGgX23/ehPhuAQtDPxGi0IBfO4tV
0vvmSCgR4yMSkGJDLQL5NKAriOKu5s0tAgnWaFqAXluRefFctURVchN3tU2TJ7Sf
1giz5jbhJbcPWWGOL2ABjPiVKmbhFFfP8K7TeHkQVfZguI6wTZMrcJir7pzLyNnz
Vn/ylnMBBZHYMIrVJBWQOpdWIIVhTpFtJTmdxvDe6u6+JtbvpEla1ptocsATka9T
EvxwPdviqg4+TRXZAx51ogD9wBvr+ed7QJriXhXmaYOxQ7nsqxfre4F4+PqHVVQ4
MBQSKu+6WIDbU3zzidDkJnrbIjtmQLepVGPLh9Gf6jO4dmQmomTqpV6Y7UmYKWDN
r3zQqiGKTeITfeCv9eyT8JiLQuSNfFwBCNxGChJdoTuqFRXf4vswEJmKQPbpVs+w
adWo0xrRLJGC+zUbL27GdNEpDsJeRRhJk7AMumsXvOjfQHnchINWZAl58d5k1Tb4
8XH5kOXR2utnFXVMZ1950XuvFZO6vOim9w/aKzWERc8aAPCMX5uJ1GUCCYNTSR8F
ii2gO+qSgl4=
=rHCK
-----END PGP SIGNATURE-----

--==_Exmh_1340217472_2019P--

