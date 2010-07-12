Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0GLO5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:57:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37276 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab0GLO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:57:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Marcin Letyns <mletyns@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
In-Reply-To: Your message of "Mon, 12 Jul 2010 15:42:32 +0300."
             <AANLkTinipHGBXVkKXHmbCdUM8tYOTAXEDrvcO-99kL81@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <201007110918.42120.Martin@lichtvoll.de> <20100711131640.GA3503@thunk.org> <4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <AANLkTil4cYsEYW9NdNyiebdaYlQnVE3yKBZwLitQyOyC@mail.gmail.com>
            <AANLkTinipHGBXVkKXHmbCdUM8tYOTAXEDrvcO-99kL81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1278946653_4501P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Jul 2010 10:57:33 -0400
Message-ID: <66102.1278946653@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4C3B2D5D.025F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1278946653_4501P
Content-Type: text/plain; charset=us-ascii

On Mon, 12 Jul 2010 15:42:32 +0300, Alexey Dobriyan said:
> On Mon, Jul 12, 2010 at 3:35 PM, Marcin Letyns <mletyns@gmail.com> wrote:
> > Last time I tried freebsd it wasn't stable. It had problems with my hard
> > drive controler.
> 
> This thread needs more anecdotal evidence.

To be fair, the continual re-appearance of this thread is *always* anecdotal.

It's always somebody who has trouble getting it to work on *their* hardware, or
with *their* software, and insisting that stuff doesn't get shipped unless it
works properly on everything.  Apparently, having it work on 99.997% of the
gear out there isn't good enough for them.  Then there's the inevitable call
for "no shipping with blocker bugs" - never with a good objective definition of
what constitutes a "blocker" bug.

Ted had it right - you insist on fixing *everything*, you end up with
Debian Obsolete.  It's the nature of the beast - you *will* detect regressions
at something resembling an exponential-decay curve. The only question that remains is
how close to zero it has to decay before the ship date - and there's no single
answer for that which fits everybody.  One point to note is that if you ship
earlier, the decay rate increases because of wider deployment.  As a result,
it's quite probable that you get to some objective level of "stable" faster
by releasing early and then releasing a half-dozen dot releases, instead of
waiting for the 3 or 4 dozen people testing it before release to shake out all
the bugs (which obviously won't happen due to things like access to hardware).

--==_Exmh_1278946653_4501P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMOy1dcC3lWbTT17ARAqf2AJ40G/9NHY+Q70d0auCTdnwdTpR7GwCfRPxD
4wSsIjtDcM0bRZ704Gm0ddE=
=rX0L
-----END PGP SIGNATURE-----

--==_Exmh_1278946653_4501P--

