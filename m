Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1DDMsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:48:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33369 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1DDMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:48:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.39-rc1] LTP hitting max (8) nested links...
In-Reply-To: Your message of "Mon, 04 Apr 2011 11:19:08 +0800."
             <BANLkTi=Mu70wYSM0sVRWZnQzTPBOvqt6xg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=pS8Wk9Ymtj=DeVqfgqBsbTXDHZA@mail.gmail.com>
            <BANLkTi=Mu70wYSM0sVRWZnQzTPBOvqt6xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1301921295_92930P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Apr 2011 08:48:15 -0400
Message-ID: <131751.1301921295@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4D99BE11.00BD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1301921295_92930P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Apr 2011 11:19:08 +0800, Daniel J Blueman said:

> Re-reading everything, nested here is actually recursively nested, not
> consecutively nested, so will never succeed, so we expect this from
> the LTP test.

We expect the LTP test to be handed an error, I suspect.  The LTP test
probably shouldn't be able to provoke a BUG_ON.

--==_Exmh_1301921295_92930P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNmb4PcC3lWbTT17ARAo1hAKD8XBfHdnkWdisSWsn+m0TGX7+NwACgwpI7
8QepILms6E4gcQJ0FMKTFA8=
=5Fka
-----END PGP SIGNATURE-----

--==_Exmh_1301921295_92930P--

