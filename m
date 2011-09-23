Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1IWXe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:34:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56898 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1IWXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:34:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Simon Glass <sjg@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
In-Reply-To: Your message of "Fri, 23 Sep 2011 16:03:15 PDT."
             <1316818998-30711-1-git-send-email-sjg@chromium.org>
From: Valdis.Kletnieks@vt.edu
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316820861_33036P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 19:34:21 -0400
Message-ID: <37959.1316820861@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E7D177D.00E9,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316820861_33036P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Sep 2011 16:03:15 PDT, Simon Glass said:
> This experimental patch set adds boot timing to a Linux system. The
> timing starts with the boot loader and extends through the kernel into
> user space to the completion of the boot process. The timing starts when
> the system leaves reset, not later when the kernel starts.
> The bootstage record aims to provide 20-30 timestamps ranging from reset
> to login prompt (or some other definition of completion).

Any way to make this play nice with bootchart, which provides much finer
detail records once userspace gets started?

https://github.com/mmeeks/bootchart



--==_Exmh_1316820861_33036P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfRd9cC3lWbTT17ARAuVXAKCZoEqDIfb8rtfSZUv9S4EF0CAdjQCgsM4+
I0UgYEMbqDneTnk+TOLLOHU=
=rE0F
-----END PGP SIGNATURE-----

--==_Exmh_1316820861_33036P--

