Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab2JYB0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:26:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33102 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2JYB0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:26:03 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/193] remove CONFIG_EXPERIMENTAL
In-Reply-To: Your message of "Tue, 23 Oct 2012 13:01:13 -0700."
             <1351022666-6960-1-git-send-email-keescook@chromium.org>
From: Valdis.Kletnieks@vt.edu
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1351128330_19242P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Oct 2012 21:25:30 -0400
Message-ID: <59643.1351128330@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.5088950B.0066,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1351128330_19242P
Content-Type: text/plain; charset=us-ascii

On Tue, 23 Oct 2012 13:01:13 -0700, Kees Cook said:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default (especially in distro builds). As agreed
> during the Linux kernel summit, it should be removed.
>
> As such, this is the patch series for removing CONFIG_EXPERIMENTAL,
> with the hopes of all the various maintainers pulling these changes into
> their trees.  I'm carrying the first patch (that makes CONFIG_EXPERIMENTAL
> "default y") in my linux-next tree, so builds there will see the impact
> immediately.

Has anybody tested what happens if you're doing a git bisect that ends up crossing
back and forth across the commit for this?  I've been burned before when stuff
evaporates out of my .config during a bisect when an option grows/loses a 'depends
on' clause.

--==_Exmh_1351128330_19242P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUIiVCgdmEQWDXROgAQKhog/8DNo8VYqgsdxt8kiYHa59xEOn/KfmZtE7
FPZClYZTm42o3c9cJ60381YS3O+6CrmqDQkYs1NkBRQENJYH/RARYY81jz8R9WaQ
HOBULfPk0o1dkYZ7zt0eIT15sY72XlF+Kg1uEytOolsidv7z1xZfEyBDC5EndTI+
/liYRpLTcQu6uRIFmsLWlZY+bsrgAITY4PzGHe0xkEuCsWopExmw49JoZSsSDJwt
eSry3W+pBP/mX9HHQqdOiAXWDkpAOhqEKiKfzApPhaV3WaKnxtKkppgn4q0EmO2V
iTrB2gzIN7iuwce7vrmq8hhzScn+7MqMnOhAP32ldRf1W75HVCSTAcvLCruHlrSw
r/+Qt1+ase9/a7Dn92jgTO5kv60zLMGCtmhGeYNDYpu3P6OD2tiYLBcRDAhzt+IH
qtqyJDgmOQdSvYjzSAXeUFg0x/D8UN176uP872wB2VUKv5EY6SI1llN6AQLIbREl
l5eBjmVf7wgKVR974WCwl+PhyRPVnhyOOcgnsxDVAgaTeqzqaC4OyCnN/rLjHoK1
B3R0Hgt8YDYuDjviwgo0nevgO+YWVIn/MTzy+ifzYA6V8jxPFgRbmrl0eH34kY7F
qOJrYIhSQbURBW+i4ytW1LCZbJFeG9rd+lSud7mOTO4Y6alAFrIi3r18Pn6AUMHx
uJBI0clRlfo=
=A95t
-----END PGP SIGNATURE-----

--==_Exmh_1351128330_19242P--

