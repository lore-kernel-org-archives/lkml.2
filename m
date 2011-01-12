Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1ALWSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:18:14 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:59496 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1ALWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:18:11 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on NET)
In-Reply-To: Your message of "Wed, 12 Jan 2011 16:58:26 EST."
             <alpine.LFD.2.02.1101121654000.19754@x980>
From: Valdis.Kletnieks@vt.edu
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au> <alpine.LFD.2.02.1101121257580.18873@x980> <20110112131800.d64c1a86.akpm@linux-foundation.org> <201101122224.54330.rjw@sisk.pl>
            <alpine.LFD.2.02.1101121654000.19754@x980>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294870540_34736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Jan 2011 17:15:40 -0500
Message-ID: <39920.1294870540@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4D2E280F.0042,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294870540_34736P
Content-Type: text/plain; charset=us-ascii

On Wed, 12 Jan 2011 16:58:26 EST, Len Brown said:

> Kconfig select needs to be fixed so that it is not possible to
> select something if that something's dependencies are not met.

Amen to that. Got bit by that in the CONFIG_XT_MATCH_REALM thread, it was
trying to do a select on NET_CLS_ROUTE, which depended on NET_SCHED which was
unset...


--==_Exmh_1294870540_34736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNLigMcC3lWbTT17ARAt4+AJ4pH/LHguHhKwZ5ZJbNW6PgOaJSmQCeLPAe
5C5/Hireq204xQYUlpQgoKc=
=1Znu
-----END PGP SIGNATURE-----

--==_Exmh_1294870540_34736P--

