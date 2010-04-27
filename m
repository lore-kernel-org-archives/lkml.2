Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0D0LxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:53:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35744 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0D0LxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:53:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
In-Reply-To: Your message of "Sun, 25 Apr 2010 06:37:30 PDT."
             <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default>
From: Valdis.Kletnieks@vt.edu
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default> <4BD336CF.1000103@redhat.com>
            <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272369145_5118P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Apr 2010 07:52:25 -0400
Message-ID: <72951.1272369145@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4BD6CFFB.00F0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272369145_5118P
Content-Type: text/plain; charset=us-ascii

On Sun, 25 Apr 2010 06:37:30 PDT, Dan Magenheimer said:

> While I admit that I started this whole discussion by implying
> that frontswap (and cleancache) might be useful for SSDs, I think
> we are going far astray here.  Frontswap is synchronous for a
> reason: It uses real RAM, but RAM that is not directly addressable
> by a (guest) kernel.

Are there any production boxes that actually do this currently? I know IBM had
'expanded storage' on the 3090 series 20 years ago, haven't checked if the
Z-series still do that.  Was very cool at the time - supported 900+ users with
128M of main memory and 256M of expanded storage, because you got the first
3,000 or so page faults per second for almost free.  Oh, and the 3090 had 2
special opcodes for "move page to/from expanded", so it was a very fast but
still synchronous move (for whatever that's worth).


--==_Exmh_1272369145_5118P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL1s/5cC3lWbTT17ARAmumAKCHjFyFj3JFTplh2Gvlql0yTNIP+gCfdMBX
OFkOMpZhtkWzYVdCP8d89Sw=
=sCDE
-----END PGP SIGNATURE-----

--==_Exmh_1272369145_5118P--

