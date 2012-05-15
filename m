Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966629Ab2EOTwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:52:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40981 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965947Ab2EOTwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:52:19 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Hyeoncheol Lee <cheol.lee@lge.com>
Subject: Re: [QUESTION] Kprobes as a module?
In-Reply-To: Your message of "Tue, 15 May 2012 17:24:11 +0900."
             <87zk99zwb8.fsf@sejong.aot.lge.com>
From: valdis.kletnieks@vt.edu
References: <87zk99zwb8.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1337111535_2773P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 May 2012 15:52:15 -0400
Message-ID: <52488.1337111535@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.161.180 mail-gg0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4FB2B3F2.003D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1337111535_2773P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 May 2012 17:24:11 +0900, Namhyung Kim said:
> Probably a dumb question :).
> What prevents the kprobes from being built as a module? We want to use
> the kprobes on our systems, but some guys worried about potential
> security problems. So it'd be great if we can enable/load kprobes as
> needed and then disable/unload after using it. Is it a possible senario?

Any troublemaker who has the ability to set a kprobe would probably also
have theability to just re-load the module before setting the kprobe (unless
you go to a *lot* of trouble to compartmentalize the root user).

So it's not clear there's a security benefit from making it a module.  If anything,
it makes it *worse* because you can then surprise a sysadmin who *thought*
they were running a KPROBES=n kernel by loading a module and turning it on...

--==_Exmh_1337111535_2773P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT7Kz7wdmEQWDXROgAQIitQ/+PEDRX4o5Cq02pgg63CDyzMei7oDwoan8
KJfKya/t9K9pHSGYyXemZuae9t6hOutUcHVuriHyBDhz8VF3cV9wlm9I6EutzN8N
fuHEKv5byyJf9goAMmTmgtSNV5uvINPDx4ZY1skz+ICWG9en/Fys5AS4smQPufTa
9shcGw+BB2GFxf4wp8vXdNcKxyA9lkYePrLO2F4PgEE3m0JqmEN9MYqVoBcwqZQB
oCpUF9kfa4evdMWB3x+8NyNq9Xpnc3FKLsHipot8HMWaJ6BYHqNISg1TjZLPDboR
3g/HL5XgWreOPSd//XPFTcZ5kuLss0w/gnRbXVL2pmQjssloM/+7io5oyxG7/ZTj
mOy2vKptvYMJCUABde9F724zezFlQMxa1VrTBapJlf9IEwh3UMeBMq0RuQSybu2M
qcqQu11PFrcN6i0ctvFU3V3pUDD9+YbR1RQPpKYjiOQHhwkgBP1tZBLBVcOU/PEy
cfhBF0eR75oH/1t+BkvWs8oakzsoa+msDVpKIrGwMUa4qZUSNAmbQBpjuRH1g4PM
ONTG2qQes3P4ymLoeQ9H5KweJNe/tnyqu5RiHwS2Qg2UwqLVXHFke7VsEJYE/7Gq
0sSvOuPuG0fXvbsEDSLMCMZ9j6egsWKdHZt4c1R+DDyf5T8wcCXA8VI4A5CRsGgq
X9CKCozU1OE=
=mcZ/
-----END PGP SIGNATURE-----

--==_Exmh_1337111535_2773P--

