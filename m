Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1JMA5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:57:47 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33208 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1JMA5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:57:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: RFC : fat : default errors use FAT_ERRORS_CONT instead of FAT_ERRORS_RO.
In-Reply-To: Your message of "Thu, 13 Oct 2011 09:24:52 +0900."
             <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318467461_2509P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Oct 2011 20:57:41 -0400
Message-ID: <13498.1318467461@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E963787.0029,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318467461_2509P
Content-Type: text/plain; charset=us-ascii

On Thu, 13 Oct 2011 09:24:52 +0900, NamJae Jeon said:

> It said windows fat provide a chance that continuously access
> partition except corrupted file.

It also gives you a chance to make things worse by continuing to write to the
device.  If you force it RO at the first sign of trouble, maybe you lose a few
blocks of one file.  If you keep writing to it, creating new files, erasing
files, and so on, pretty soon your corrupted filesystem is even more corrupted.

> I suggest that the default errors of linux fat use FAT_ERRORS_CONT
> instead of FAT_ERRORS_RO.

And what user benefit does that give?  If you keep going, they won't
realize their device is corrupted, and won't have any reason to *fix* the
filesystem.

--==_Exmh_1318467461_2509P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOljeFcC3lWbTT17ARAm8HAKCgBTt0Bhi+1dib+RmUXOF4l57rfACgvHEV
8RMb7ya2i705jgtjZHX5/4U=
=H/dy
-----END PGP SIGNATURE-----

--==_Exmh_1318467461_2509P--

