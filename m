Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab1LODVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:21:07 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:35591 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab1LODVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:21:05 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Xi Wang <xi.wang@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: signedness bug in cma3000_thread_irq()
In-Reply-To: Your message of "Wed, 14 Dec 2011 21:35:22 EST."
             <ECD4A42B-AC97-417B-99CA-3856B5DAFAC6@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1323672566-16738-1-git-send-email-xi.wang@gmail.com> <12775.1323916035@turing-police.cc.vt.edu>
            <ECD4A42B-AC97-417B-99CA-3856B5DAFAC6@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1323919260_3689P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Dec 2011 22:21:00 -0500
Message-ID: <3797.1323919260@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4EE9679F.00B4,ss=1,re=0.000,fgs=0,
	ip=71.62.120.57,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1323919260_3689P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Dec 2011 21:35:22 EST, Xi Wang said:
> On Dec 14, 2011, at 9:27 PM, Valdis.Kletnieks@vt.edu wrote:
> > That will fix the signed/unsigned issue.  However, was there a reason
> > the field was an 8-bit-wide to begin with?
>
> Which field?  The ->read() function pointer?

No, the variable that used to be a u8 - was it 8 bits wide for a reason?

--==_Exmh_1323919260_3689P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO6WeccC3lWbTT17ARAl/dAKDZxg4rTZak3KJBZLvQLzCCxJIBiwCghJiq
9f1CjeffPASHIzxSOkxpr/c=
=yKs9
-----END PGP SIGNATURE-----

--==_Exmh_1323919260_3689P--

