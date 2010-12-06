Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0LFUCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:02:12 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56680 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0LFUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:02:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/5] msm: Secure Channel Manager (SCM) support
In-Reply-To: Your message of "Sun, 05 Dec 2010 23:16:14 PST."
             <1291619778-30289-2-git-send-email-johlstei@codeaurora.org>
From: Valdis.Kletnieks@vt.edu
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org>
            <1291619778-30289-2-git-send-email-johlstei@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291665648_4733P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Dec 2010 15:00:48 -0500
Message-ID: <29863.1291665648@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4CFD40F1.005C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291665648_4733P
Content-Type: text/plain; charset=us-ascii

On Sun, 05 Dec 2010 23:16:14 PST, Jeff Ohlstein said:

> SCM is the protocol used to communicate between the secure and
> non-secure code executing on the applications processor. 

Does the presence of SCM hardware imply SMP?  From reading this, it's unclear
why the dependence on SMP - it looks like scm.c is something that hardware that
has one ARM processor and a 'secure processor' would still want.  Or is the
'secure processor' just another (arbitrarily labeled) ARM CPU participating
as a full SMP processor?


--==_Exmh_1291665648_4733P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM/UDwcC3lWbTT17ARAhT4AKDit4oYNcVR6MAXBs8z09+WAyvCWACfW6PY
lzuqPN2v8vQrWGM12BlmdtM=
=CdKU
-----END PGP SIGNATURE-----

--==_Exmh_1291665648_4733P--

