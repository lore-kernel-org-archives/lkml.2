Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1JDTVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:21:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34299 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1JDTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:21:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
In-Reply-To: Your message of "Tue, 04 Oct 2011 20:59:55 +0200."
             <1317754795.32543.32.camel@twins>
From: Valdis.Kletnieks@vt.edu
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
            <1317754795.32543.32.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317756054_10919P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Oct 2011 15:20:54 -0400
Message-ID: <23749.1317756054@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E8B5C99.01FD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317756054_10919P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Oct 2011 20:59:55 +0200, Peter Zijlstra said:

> How about another option that also allows you to pick they key used for
> signing things?

Are there many people that will be signing with a key other than their default key?
Or is a 'default-key' entry in ~/.gnupg/gpg.conf sufficient?


--==_Exmh_1317756054_10919P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOi1yWcC3lWbTT17ARAge0AKDfJfNI2nZ85awsHdOjTTcOqwRr7gCeOd2l
Fpr3g+ElA1ZWs6LE3wtXuHM=
=yOdD
-----END PGP SIGNATURE-----

--==_Exmh_1317756054_10919P--

