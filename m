Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2CWBOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 21:14:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56011 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2CWBOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:14:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Eric Paris <eparis@parisplace.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov
Subject: Re: 3.3.0-next-20120321 crash in mls_compute_sid at boot time...
In-Reply-To: Your message of "Thu, 22 Mar 2012 14:12:42 -0400."
             <CACLa4pu22sZm4STNSXoOfeyw1BRK06Gu30Ec=6RAqUP+egxRHw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <8414.1332439350@turing-police.cc.vt.edu>
            <CACLa4pu22sZm4STNSXoOfeyw1BRK06Gu30Ec=6RAqUP+egxRHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332465273_1929P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Mar 2012 21:14:33 -0400
Message-ID: <3669.1332465273@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4F6BCE7B.0063,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332465273_1929P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Mar 2012 14:12:42 -0400, Eric Paris said:
> It's known and should be fixed in linux-next from today.  If not, let me know!

> > [  28.069261] BUG: unable to handle kernel NULL pointer dereference at 000000000000003b
> > [  28.069558] IP: [<ffffffff81219974>] mls_compute_sid+0x99/0x104

Confirming fixed in next-20120322, thanks...

--==_Exmh_1332465273_1929P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2vOeQdmEQWDXROgAQLcOw//emGf3o540sqvYaSa+WfMnq+SKTUBKQuj
XYH3w+qOaGgkaUX3qxLt2m3lMe+I+fQerbOxzZin+sSEEjKj5WuapnuPn/Y15eYo
3E9sJfgELLpKMU44Oh1t9EwoEm374vear9cHHwt4KRkS9REYw/VZAYrWEmF/8dM1
xo1wZEhM+ZDIqfZALCwi3Z0clmWtkE1gzut2/HZGKG2mYF73tbP8r8+2w4gUFnJM
TFLF7a7Dkh7efUIp3zMJrKxD58zTGlDCQFG8dm//68W2BH25o2JjNh/MLAp9K42B
zCLp3Bl+W9QE5ei2eh4X5FiE8HlikZlHKycjWBQfOCzjzb2Vo3mott4mgkGB3Mot
l7uY0B9P08NfgABwnjkfQ30Bx/qJQhiCxrli25s73C1kJgfnXVRx4ClfVwGQ4b7i
Zm7sx1Uwn/y/UZhAokBcMmT+J5IPgIEGHXtqpy/r/5tWH5/Axp2kXeArvyLda2pJ
Xa9/kZQ5wQDGJTUwYF0mBWqJX7o7vpqKfy46OIFy+O2Ky4gq34mXnG8dIs94sJtl
4a+bdvCsYhWfXNYv+EpVqlX6Cem54tpcKtwqlJGm5FO18v4IUWCW1bNb06cv9c4S
1+HtWVVDttfOZVwzp5k0Gp9YVrIY6cuJD5+a+lc4JirgWfMxXKo0NcDdwupEJ3er
mzuHSY+SoIU=
=2JFp
-----END PGP SIGNATURE-----

--==_Exmh_1332465273_1929P--

