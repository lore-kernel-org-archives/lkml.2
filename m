Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab0J2OPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:15:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49941 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab0J2OPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:15:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] IMA: maintain i_readcount in the VFS layer
In-Reply-To: Your message of "Thu, 28 Oct 2010 18:02:03 EDT."
             <1288303325-9628-3-git-send-email-zohar@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
            <1288303325-9628-3-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1288361618_4998P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Oct 2010 10:13:38 -0400
Message-ID: <6166.1288361618@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4CCAD693.013E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1288361618_4998P
Content-Type: text/plain; charset=us-ascii

On Thu, 28 Oct 2010 18:02:03 EDT, Mimi Zohar said:
> ima_counts_get() updated the readcount and invalidated the PCR,
> as necessary. Only update the i_readcount in the VFS layer.
> Move the PCR invalidation checks to ima_file_check(), where it
> belongs.
> 
> Maintaining the i_readcount in the VFS layer, will allow other
> subsystems to use i_readcount.

Would a symmetric i_writecount be useful for anything?  If it existed,
could any code be simplified elsewhere?


--==_Exmh_1288361618_4998P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMytaScC3lWbTT17ARAly8AJ0Y+I8WrqgNUlbAuPqt9WOhW7vmNwCggC9Q
5xBbiRhnwZPtFWKpuE4NhwU=
=PnvS
-----END PGP SIGNATURE-----

--==_Exmh_1288361618_4998P--

