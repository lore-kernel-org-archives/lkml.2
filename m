Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1EDTU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:20:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33941 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1EDTU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:20:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
In-Reply-To: Your message of "Wed, 04 May 2011 15:10:20 EDT."
             <4DC1A49C.4010101@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost>
            <4DC1A49C.4010101@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304536851_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 May 2011 15:20:51 -0400
Message-ID: <16280.1304536851@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DC1A714.00D7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304536851_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 15:10:20 EDT, Josef Bacik said:

> Yeah sorry the log says "nearest" but the code says "next", if you look 
> at it thats how it works.  Thanks,

Oh good - the changelog is usually easier to fix than the code is. :)

Probably want to fix the changelog before it gets committed, as there's a fair
chance that text will end up being used as the basis for a manpage or other
documentation.


--==_Exmh_1304536851_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwacTcC3lWbTT17ARAjJiAJ9l9/l5RNEafTbHd/DT2CFfC5216ACgnFEV
uq/MaPi1c5I/dGQBzOcmpXo=
=FwjA
-----END PGP SIGNATURE-----

--==_Exmh_1304536851_7352P--

