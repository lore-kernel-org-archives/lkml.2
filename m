Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0LAWrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 17:47:06 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50403 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0LAWrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 17:47:03 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jamie Lokier <jamie@shareable.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
In-Reply-To: Your message of "Wed, 01 Dec 2010 10:43:59 GMT."
             <20101201104359.GJ22787@shareable.org>
From: Valdis.Kletnieks@vt.edu
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org> <20101123224346.GA19350@tango.0pointer.de>
            <20101201104359.GJ22787@shareable.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291243569_5106P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Dec 2010 17:46:09 -0500
Message-ID: <20180.1291243569@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4CF6D032.01C7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291243569_5106P
Content-Type: text/plain; charset=us-ascii

On Wed, 01 Dec 2010 10:43:59 GMT, Jamie Lokier said:

> So maybe CLOCK_MONOTONIC should be changed to include elapsed time
> during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
> for programs that want that?

Wouldn't that be an API break for programs that are expecting the current
behavior of CLOCK_MONOTONIC?  Yes, there should be a way to request either of
them - but if there's only one way now, it should continue to act the current
way, and the added way is the second option.


--==_Exmh_1291243569_5106P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM9tAxcC3lWbTT17ARAq83AKD3l4x8J6GenNArbVxWjroVAqYMBQCgx6jH
0zSg7GwZh+i6qj6oBH0g4Do=
=Jrmy
-----END PGP SIGNATURE-----

--==_Exmh_1291243569_5106P--

