Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1J2TNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:13:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35128 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1J2TNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:13:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
In-Reply-To: Your message of "Wed, 26 Oct 2011 16:22:35 EDT."
             <20111026202235.GA20928@havoc.gtf.org>
From: Valdis.Kletnieks@vt.edu
References: <20111026202235.GA20928@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319915586_3122P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Oct 2011 15:13:06 -0400
Message-ID: <28364.1319915586@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4EAC5047.005B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319915586_3122P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Oct 2011 16:22:35 EDT, Jeff Garzik said:

>    For this reason, I am tempted to modify my new, GPG-signed pull request
>    template as follows, for subsequent pull requests:
> 
> 	---<begin GPG signed text>---
> 
>    	pull req description
> 
> 	"Please pull from $branch\n$url $branch"
> 
> 	"Top of tree is $sha1_commit"
> 
> 	---<end GPG signed text>---
> 
> 	diffstat
> 	diff

Note that this can be problematic as well - there's probably a lot of tools out there
that will be less than gracious when presented with a GPG-signed text with non-signed
trailing text.  Maybe GPG-sign from "pull request" to "diffstat" and make the diff an
attachment? (That would also allow attaching a gzip'ed diff, which would save vger's
bandwidth :)

--==_Exmh_1319915586_3122P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOrFBCcC3lWbTT17ARArL0AKCO3joUvywQDH+AzvxXBb35Jl24IgCeLTjl
SphzIrWvZAHiJk9EgQaceIw=
=Ern0
-----END PGP SIGNATURE-----

--==_Exmh_1319915586_3122P--

