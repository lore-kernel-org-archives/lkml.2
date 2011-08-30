Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1H3UHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:07:18 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40299 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab1H3UHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:07:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James.Bottomley@HansenPartnership.com,
        dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
In-Reply-To: Your message of "Sat, 27 Aug 2011 21:54:29 +0900."
             <4E58E905.4020704@hitachi.com>
From: Valdis.Kletnieks@vt.edu
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com> <20110827102655.GJ2632@htj.dyndns.org>
            <4E58E905.4020704@hitachi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314734537_2796P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Aug 2011 16:02:17 -0400
Message-ID: <16628.1314734537@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E5D41CC.0036,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314734537_2796P
Content-Type: text/plain; charset=us-ascii

On Sat, 27 Aug 2011 21:54:29 +0900, Nao Nishijima said:

> A kernel device names (e.g. sda) is not useful information because it
> doesn't always point the same disk at each boot-up time.

If this is important to you, can't you use a udev rule, similar to what most
distros already stick in 70-persistent-net.rules and 70-persistent-cd.rules?

(Yes, this *does* involve finding a UUID or label or  something on the disk
that you can identify as "same entity as last time".


--==_Exmh_1314734537_2796P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOXUHJcC3lWbTT17ARArGuAKC+725LVYwb/dYGXwY4YFM3659a3wCg3zqZ
W/jiW7MSazRurJWosEVFpaY=
=DGkn
-----END PGP SIGNATURE-----

--==_Exmh_1314734537_2796P--

