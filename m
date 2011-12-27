Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab1L0UGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 15:06:14 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:45659 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1L0UFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 15:05:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com
Subject: Re: [PATCH V2 1/6] drivers/staging/ramster: cluster/messaging foundation
In-Reply-To: Your message of "Thu, 22 Dec 2011 07:50:50 PST."
             <20111222155050.GA21405@ca-server1.us.oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <20111222155050.GA21405@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1325016332_3579P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Dec 2011 15:05:32 -0500
Message-ID: <243729.1325016332@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4EFA2510.0159,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1325016332_3579P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Dec 2011 07:50:50 PST, Dan Magenheimer said:

> Copy cluster subdirectory from ocfs2.  These files implement
> the basic cluster discovery, mapping, heartbeat / keepalive, and
> messaging ("o2net") that ramster requires for internode communication.

Instead of doing this, can we have the shared files copied to a common
subdirectory so that ramster and ocfs2 can share them, and we only
have to fix bugs once?

--==_Exmh_1325016332_3579P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO+iUMcC3lWbTT17ARAmGfAKCENDjN79TxO+C7OZ06guBX0h6vowCgusxg
htspX2q/+e756QN70cO8BEg=
=d18g
-----END PGP SIGNATURE-----

--==_Exmh_1325016332_3579P--

