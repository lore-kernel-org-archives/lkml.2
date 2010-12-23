Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0LWHGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 02:06:11 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40532 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0LWHGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 02:06:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC -v9 4/4] net, rds, Replace xlist in net/rds/xlist.h with llist
In-Reply-To: Your message of "Thu, 23 Dec 2010 13:43:23 +0800."
             <1293083003-19577-5-git-send-email-ying.huang@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
            <1293083003-19577-5-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293087917_5070P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Dec 2010 02:05:17 -0500
Message-ID: <25219.1293087917@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4D12F4B0.011E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293087917_5070P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Dec 2010 13:43:23 +0800, Huang Ying said:
> The functionality of xlist and llist is almost same.  This patch
> replace xlist with llist to avoid code duplication.

>  /*
> - * this takes a list head of mrs and turns it into an xlist of clusters.
> - * each cluster has an xlist of MR_CLUSTER_SIZE mrs that are ready for
> - * reuse.
> + * this takes a list head of mrs and turns it into linked llist nodes.
>   */

This comment change loses a lot of information.  The original 3 lines
tells me a lot about what the data structure is and what it's used for,
the replacement is a 'b +=5; /* add 5 to b */' type of comment.



--==_Exmh_1293087917_5070P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNEvStcC3lWbTT17ARAjgAAKCmK/izYqoD6hUvxD3dxbZYF1o5nwCfSvYM
K7qdROFBSNK5SbbnapPIgs0=
=J9tF
-----END PGP SIGNATURE-----

--==_Exmh_1293087917_5070P--

