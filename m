Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab0J2PQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:16:48 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37869 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761497Ab0J2PQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:16:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] IMA: maintain i_readcount in the VFS layer
In-Reply-To: Your message of "Fri, 29 Oct 2010 10:13:38 EDT."
             <6166.1288361618@localhost>
From: Valdis.Kletnieks@vt.edu
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com> <1288303325-9628-3-git-send-email-zohar@linux.vnet.ibm.com>
            <6166.1288361618@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1288365318_4998P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Oct 2010 11:15:18 -0400
Message-ID: <8750.1288365318@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4CCAE507.0152,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1288365318_4998P
Content-Type: text/plain; charset=us-ascii

On Fri, 29 Oct 2010 10:13:38 EDT, Valdis.Kletnieks@vt.edu said:

> Would a symmetric i_writecount be useful for anything?  If it existed,
> could any code be simplified elsewhere?

-ENOCAFFIENE. :)

--==_Exmh_1288365318_4998P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMyuUGcC3lWbTT17ARAiREAKDCHVCHPxJQoGxbQ3TbfUX5DfNHGQCdFQ6S
VHxXL9/vKf7apf8Z7kguDCI=
=X7eN
-----END PGP SIGNATURE-----

--==_Exmh_1288365318_4998P--

