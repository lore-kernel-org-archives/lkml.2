Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0ERV00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:26:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42405 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0ERV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:26:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Soren Hansen <soren@linux2go.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Allow hvc tty's to pose as vt's
In-Reply-To: Your message of "Fri, 14 May 2010 18:10:12 +0200."
             <0dd0991d71cac0a746891863264941c100bbc67a.1273825543.git.soren@linux2go.dk>
From: Valdis.Kletnieks@vt.edu
References: <cover.1273825543.git.soren@linux2go.dk>
            <0dd0991d71cac0a746891863264941c100bbc67a.1273825543.git.soren@linux2go.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1274217979_3866P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 May 2010 17:26:19 -0400
Message-ID: <21909.1274217979@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4BF305FB.010C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1274217979_3866P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 May 2010 18:10:12 +0200, Soren Hansen said:
> Allow for hvc based tty's to take over the vt driver's major number
> and namespace.

> +#ifdef CONFIG_HVC_TTY_HACK
> +#define HVC_MAJOR	4
> +#else /* CONFIG_HVC_TTY_HACK */
>  #define HVC_MAJOR	229
> +#endif /* CONFIG_HVC_TTY_HACK */
>  #define HVC_MINOR	0

Out of curiosity, what happens if you boot a kernel with this config hack
on a system that has real live "plain old ttys"?

--==_Exmh_1274217979_3866P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL8wX7cC3lWbTT17ARAocGAKCwJP7i/j/VGIhiRUXydC9FAMP4uACg5AuR
grRibS9q8BbZo3Ab6NaPluk=
=u3ru
-----END PGP SIGNATURE-----

--==_Exmh_1274217979_3866P--

