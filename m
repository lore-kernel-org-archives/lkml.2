Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab1E3UuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:50:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53913 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1E3UuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:50:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mustapha Rabiu <muztapha@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0-rc1
In-Reply-To: Your message of "Mon, 30 May 2011 20:33:29 -0000."
             <loom.20110530T221016-75@post.gmane.org>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
            <loom.20110530T221016-75@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306788607_2897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 May 2011 16:50:07 -0400
Message-ID: <20293.1306788607@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DE40301.002E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306788607_2897P
Content-Type: text/plain; charset=us-ascii

On Mon, 30 May 2011 20:33:29 -0000, Mustapha Rabiu said:
> Linus Torvalds <torvalds <at> linux-foundation.org> writes:
> 
> > 
> > Yay! Let the bikeshed painting discussions about version numbering
> > begin (or at least re-start).
> > 
> > I decided to just bite the bullet, and call the next version 3.0. It
> > will get released close enough to the 20-year mark, which is excuse
> > enough for me, although honestly, the real reason is just that I can
> > no longe rcomfortably count as high as 40.
> > 
> 
> Unsurprising, however, congratulations on yet another major release! 
> We applaud the fact that it'll be just as hideous as 2.6.x, without any 
> new or modified features. Might you explain why you didn't just 
> use 2.8.x ?
> 
> Also, given that multiple people have asked for a handful of things
> to be merged into the kernel, re: security, I'm puzzled about how 
> you managed to develop this self-styled 'alpha-male' based versioning 
> scheme without addressing unsettling discrepancies such 
> as /proc/pid/auxv, /proc/pid/stack and /proc/pid/syscall based 
> info-leaks or slub cache merging, etc, all of which have been publicly 
> discussed over varying periods of time, (circa ~2008)

We can come back and revisit those issues after we get done fixing
*all* the software that made a blind assumption that the kernel
release number matches '2\.[46]\.[0-9]+' (said assumption being
broken at *both* ends by a 3.0 release.

I have to agree with Linus on this one - if we're ruling out ABI-breaking
changes, we want to make this kernel release as little different as
we can.

--==_Exmh_1306788607_2897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN5AL/cC3lWbTT17ARAi85AKDrxI8WQRHAHxe3dpQ8ksq0hluKjwCgoub5
2ZyNoegRVnePXaIl4IcssCA=
=2iWX
-----END PGP SIGNATURE-----

--==_Exmh_1306788607_2897P--

