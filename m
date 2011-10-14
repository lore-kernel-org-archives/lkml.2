Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab1JNC6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 22:58:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46209 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1JNC57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 22:57:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Glauber Costa <glommer@parallels.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        paul@paulmenage.org, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
In-Reply-To: Your message of "Fri, 14 Oct 2011 00:05:58 +0400."
             <4E9744A6.5010101@parallels.com>
From: Valdis.Kletnieks@vt.edu
References: <1318511382-31051-1-git-send-email-glommer@parallels.com> <20111013.160031.605700447623532119.davem@davemloft.net>
            <4E9744A6.5010101@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318560959_28908P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Oct 2011 22:55:59 -0400
Message-ID: <60642.1318560959@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4E97A4C7.0139,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318560959_28908P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Oct 2011 00:05:58 +0400, Glauber Costa said:
> On 10/14/2011 12:00 AM, David Miller wrote:

> > Make this evaluate into exactly the same exact code stream we have
> > now when the memory cgroup feature is not in use, which will be the
> > majority of users.
> 
> What exactly do you mean by "not in use" ? Not compiled in or not 
> actively being exercised ? If you mean the later, I appreciate tips on 
> how to achieve it.
> 
> Also, I kind of dispute the affirmation that !cgroup will encompass
> the majority of users, since cgroups is being enabled by default by
> most vendors. All systemd based systems use it extensively, for instance.

Yes, systemd requires a kernel that includes cgroups.  However, systemd does
*not* require the memory cgroup feature.  As a practical matter, if your patch
doesn't generate equivalent code for the "have cgroups, but no memory cgroup"
situation, it's a non-starter.

--==_Exmh_1318560959_28908P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOl6S/cC3lWbTT17ARArxnAKDanOuIMQXHrs/wd4CYgmiG8QsllQCeN/MT
xx+W0iVP/IssCSI12NSp7yI=
=czOf
-----END PGP SIGNATURE-----

--==_Exmh_1318560959_28908P--

