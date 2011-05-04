Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1EDTb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:31:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36532 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1EDTbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:31:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, TB <lkml@techboom.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Divide error in bictcp_cong_avoid ?
In-Reply-To: Your message of "Wed, 04 May 2011 11:33:51 PDT."
             <20110504113351.4643a0c9@nehalam>
From: Valdis.Kletnieks@vt.edu
References: <4DC178D3.6030308@techboom.com> <20110504104940.cd0d9e9a.rdunlap@xenotime.net>
            <20110504113351.4643a0c9@nehalam>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304537481_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 May 2011 15:31:21 -0400
Message-ID: <16668.1304537481@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DC1A98A.002A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304537481_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 11:33:51 PDT, Stephen Hemminger said:

> What kernel version? I suspect they are running something really old
> kernel like RHEL 5 since BIC has not been the default congestion control for
> several years.

Pretty bleeding edge here, and BIC is *still* the default:

% uname -a
Linux turing-police.cc.vt.edu 2.6.39-rc5-mmotm0429 #1 SMP PREEMPT Sat Apr 30 00:36:49 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
% zgrep -i BIC /proc/config.gz 
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_DEFAULT_BIC=y
CONFIG_DEFAULT_TCP_CONG="bic"

Why? Because BIC was working "well enough", so I never changed it by hand, and
"make oldconfig" never changed it automagically either.  Now, 


--==_Exmh_1304537481_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwamJcC3lWbTT17ARAr+6AKCdKmV8Bq6F2lh5wEq46/cyi4js6wCfXz40
wcMPCc17PaxksJCuEB56UdQ=
=0NR+
-----END PGP SIGNATURE-----

--==_Exmh_1304537481_7352P--

