Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab1JFTxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:53:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54426 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935270Ab1JFTxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:53:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
In-Reply-To: Your message of "Thu, 06 Oct 2011 15:50:07 EDT."
             <20111006195007.GA24900@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20111006190526.GA13883@redhat.com> <20111006194432.GA21642@kroah.com>
            <20111006195007.GA24900@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317930822_2653P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Oct 2011 15:53:42 -0400
Message-ID: <14371.1317930822@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E8E0747.0059,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317930822_2653P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Oct 2011 15:50:07 EDT, Dave Jones said:

> I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
> Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?

That would fix my biggest issue with the patch - it's a slippery slope.  But if
we bite the bullet and go straight to the bottom of the slope with an
OUT_OF_TREE taint, I'd be happy with that.

Is there a good way to identify at modprobe time if a module is in-tree or
out-of-tree?


--==_Exmh_1317930822_2653P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjgdGcC3lWbTT17ARAk7YAJ498basNslZwB91XrReLDvDB1pIvwCfVt+p
oTwBl1xiHVN8DWnZ+AyxB9k=
=3fFQ
-----END PGP SIGNATURE-----

--==_Exmh_1317930822_2653P--

