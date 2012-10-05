Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab2JEV3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:29:33 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59203 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2JEV3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:29:30 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.5-rc7
In-Reply-To: Your message of "Sun, 30 Sep 2012 14:54:07 +0200."
             <op.wlf8shgd6426ze@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <op.wlf8shgd6426ze@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1349472563_2935P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Oct 2012 17:29:23 -0400
Message-ID: <49825.1349472563@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.506F5134.0093,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1349472563_2935P
Content-Type: text/plain; charset=us-ascii

On Sun, 30 Sep 2012 14:54:07 +0200, Uwaysi Bin Kareem said:
> Compiled 3.6-rc7, with a hz timer of 3956 for a "natural" psychovisual
> profile jitter level in OpenGL, and a shaved config for minimal jitter.

I'll bite - how did you measure the difference between 3956 and 4000?

The other stuff in your note sounds sane, but I'm having a hard time
believing that 3956 was arrived at in any sort of systematic or measured
way - it smells like cargo cult programming to me...

--==_Exmh_1349472563_2935P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUG9RMwdmEQWDXROgAQJ4ZA//UkNOyGSNnRtDwpglbnuAnwREigcjUJQ3
GeZnqcopZtqUY0NHh0QUZ3HID5/r78j1IoVg2VGq8jr/m44uicMLRAWXFkHro6sc
dkUR+PQmmcaG93w5k6TPudQt6J+9MpiS9WzjZcrHr3xj77TA62Vl7vqY6u8vb/8t
QnVFybLSkfvPRgQ2p6XH12106wE+q+JqQPVuR0mRHkeiXEfGJ1H/BcnlT6aad7AN
vMd2U9MZc7kAbyfV3tPBEVuEepAiJirjSRI6ym6ozjye+cmKzqziFIjZ43bsWMhw
jOBDmhw9Rfoa7eaySbxq0+7mHK8Qb2o1+lyUVo9B8tC6sTpFJ9IotraLBo6QETlV
QufVNgtWs/7b9eswLxSNwuO/QvMArSvVX8dW52b57Yv2wScjkd8RAYn79jHz22ud
5hnOyFM8UMXBe5XI9tHxCVJ1nD5IiVurmkaxjisMHN6m0sdBzgkcIyufBfB2Q7Bc
Gf0fqZSRp9xgnnmSLhpiC+mh60+A3ZY2ytJuScxV2n9SvUS4Nxmm0cGbCXCIgNH9
6KBrPQNza2r2H5OIMrpA/dM/SR/B4Zinsiok8aKZyu7r08sPlc6ySX7jN+0Rdqpv
jGHXviL/hcfdSs8d7+I3MetuF+khx+EbS6WdGZS1MQuSI5THVDeycCF5HW5ypP99
HTTdTLl0slA=
=qTz/
-----END PGP SIGNATURE-----

--==_Exmh_1349472563_2935P--

