Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1ECTbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:31:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37284 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1ECTbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:31:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Lunn <andrew@lunn.ch>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/4] Pinmux subsystem
In-Reply-To: Your message of "Tue, 03 May 2011 19:27:12 +0200."
             <20110503172712.GE6538@lunn.ch>
From: Valdis.Kletnieks@vt.edu
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
            <20110503172712.GE6538@lunn.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304450998_4857P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 May 2011 15:29:58 -0400
Message-ID: <26287.1304450998@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DC057B7.00AD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304450998_4857P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 May 2011 19:27:12 +0200, Andrew Lunn said:

> I can think of two different solutions: 
> 
> 1) Three functions: uart-3wire, uart-hw-flow, uart-hw-flow-modem.  The
>    first just has 2 pins, the second 4 and the last 8. The board code
>    selects one of these for the serial driver to use.
> 
> 2) Three functions: uart-core, uart-hw-flow, uart-mode.  The first has
>    2 pins, the second has 2 pins and the last 4 pins. The board code tells
>    the driver to use uart-core, plus say uart-hw-flow.

For this second solution, what happens if some bozo selects *only* uart-modem
but not uart-core?  If there's a strict ordering (hw-flow requires core, modem
requires both hw-flow and core), it's essentially the same thing as the first
solution.  If there's not a strict ordering (i.e you can select uart-modem
without uart-core), you need to come up with sane semantics.


--==_Exmh_1304450998_4857P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwFe2cC3lWbTT17ARApWsAKCHH0QU/iezcykZUTKsKse1CPpwQwCfUbfG
adzrr1c84848hVYeW7mthGI=
=75mF
-----END PGP SIGNATURE-----

--==_Exmh_1304450998_4857P--

