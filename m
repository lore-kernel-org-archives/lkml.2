Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab1JXQ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:56:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35313 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab1JXQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:56:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz
Subject: Re: [PATCH RFC] try to create KBUILD_OUTPUT automatically
In-Reply-To: Your message of "Sat, 22 Oct 2011 11:12:29 EDT."
             <alpine.LNX.2.00.1110221049460.59156@linux>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LNX.2.00.1110221049460.59156@linux>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319475304_2592P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Oct 2011 12:55:04 -0400
Message-ID: <8033.1319475304@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4EA59872.0032,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319475304_2592P
Content-Type: text/plain; charset=us-ascii

On Sat, 22 Oct 2011 11:12:29 EDT, Peter Foley said:
> This patch makes it possible to execute make O=work instead of
> mkdir work
> make O=work

The case can be made that this is a Bad Idea, because it means you can't catch
a typo in your O= setting.  This is particularly bad when it silently fails to
update the stuff in out-dir because you did a 'make O=out-diir'.

So NACK on this, if anybody cares what I think... ;)


--==_Exmh_1319475304_2592P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpZhocC3lWbTT17ARAl/eAJ97DHrnIkFcivMcLg/HgJbTA6pECwCfehy0
HCq3iqgo/rN5u7o+XasDpvY=
=XURA
-----END PGP SIGNATURE-----

--==_Exmh_1319475304_2592P--

