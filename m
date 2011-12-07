Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1LGMaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:30:23 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:33006 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab1LGMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:30:18 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, ludwig.nussel@suse.de, harvey.harrison@gmail.com,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86: Fix mmap random address range
In-Reply-To: Your message of "Mon, 05 Dec 2011 09:52:17 PST."
             <tip-9af0c7a6fa860698d080481f24a342ba74b68982@git.kernel.org>
From: Valdis.Kletnieks@vt.edu
References: <201111152246.pAFMklOB028527@wpaz5.hot.corp.google.com>
            <tip-9af0c7a6fa860698d080481f24a342ba74b68982@git.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1323260954_2982P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Dec 2011 07:29:14 -0500
Message-ID: <16078.1323260954@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4EDF5C1F.0094,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1323260954_2982P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Dec 2011 09:52:17 PST, tip-bot for Ludwig Nussel said:
> Commit-ID:  9af0c7a6fa860698d080481f24a342ba74b68982
> Gitweb:     http://git.kernel.org/tip/9af0c7a6fa860698d080481f24a342ba74b68982
> Author:     Ludwig Nussel <ludwig.nussel@suse.de>
> AuthorDate: Tue, 15 Nov 2011 14:46:46 -0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 5 Dec 2011 17:07:23 +0100
>
> x86: Fix mmap random address range
>
> On x86_32 casting the unsigned int result of get_random_int() to
> long may result in a negative value.  On x86_32 the range of
> mmap_rnd() therefore was -255 to 255.  The 32bit mode on x86_64
> used 0 to 255 as intended.

Will somebody please hand me a big dose of caffeine and explain to me
how the range could have been -255 to 255?  -256 maybe, or -128 to 127,
but -255??!?

--==_Exmh_1323260954_2982P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO31wacC3lWbTT17ARAmkVAJ4uDTzyayh96xQ5ekY/H/TRp3NVQACeNBKe
aNc2ROnZfc6Ahnksk7AdqW0=
=u+vg
-----END PGP SIGNATURE-----

--==_Exmh_1323260954_2982P--

