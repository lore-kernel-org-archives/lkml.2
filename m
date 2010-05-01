Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab0EANBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 09:01:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42088 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0EANBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 09:01:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Bcache: version 4
In-Reply-To: Your message of "Fri, 30 Apr 2010 16:12:13 -0800."
             <20100501001212.GA31135@moria>
From: Valdis.Kletnieks@vt.edu
References: <20100501001212.GA31135@moria>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272718901_4236P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 01 May 2010 09:01:41 -0400
Message-ID: <63479.1272718901@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4BDC2636.01D2,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272718901_4236P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Apr 2010 16:12:13 -0800, Kent Overstreet said:

> Most of the basic functionality is now there; the most visible thing is
> it's now correctly saving all the metadata, so you can unload a cache
> and then reload it, and everything will still be there.

If you unload a cache and then reload it, what prevents it from serving
up now-stale data from an extent that was modified while the cache was
unloaded?

(Telling me "Get some caffeine, it's about halfway down in patch 2" or
"We'll add that in Version 6 of the patch" are both acceptable answers" :)

--==_Exmh_1272718901_4236P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL3CY1cC3lWbTT17ARAuppAKD9g/uL+6+Wh7omfN85jBWgfnSzLQCgsaf9
efKRmfVYeKzDGut04Zm6A58=
=7v/d
-----END PGP SIGNATURE-----

--==_Exmh_1272718901_4236P--

