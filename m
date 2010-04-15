Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0DOSXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:23:11 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34925 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0DOSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:23:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
In-Reply-To: Your message of "Thu, 15 Apr 2010 14:15:33 BST."
             <20100415131532.GD10966@csn.ul.ie>
From: Valdis.Kletnieks@vt.edu
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com> <20100415192140.D1A4.A69D9226@jp.fujitsu.com>
            <20100415131532.GD10966@csn.ul.ie>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1271355721_4032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Apr 2010 14:22:01 -0400
Message-ID: <16363.1271355721@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4BC7594A.011A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1271355721_4032P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Apr 2010 14:15:33 BST, Mel Gorman said:

> Yep. I modified bloat-o-meter to work with stacks (imaginatively calling it
> stack-o-meter) and got the following. The prereq patches are from
> earlier in the thread with the subjects

Think that's a script worth having in-tree?

--==_Exmh_1271355721_4032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLx1lJcC3lWbTT17ARAqyGAKC1f3e2OAbaTieb6RAjylZZcPhsegCgs3Lo
UCfgZZyeWUYEmBR3Lfn73d4=
=mkPa
-----END PGP SIGNATURE-----

--==_Exmh_1271355721_4032P--

