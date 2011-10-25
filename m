Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1JYHrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:47:37 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35056 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1JYHrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:47:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
In-Reply-To: Your message of "Tue, 25 Oct 2011 13:52:44 +1100."
             <20111025135244.710e43fa@notabene.brown>
From: Valdis.Kletnieks@vt.edu
References: <201110132145.42270.rjw@sisk.pl> <201110231516.36787.rjw@sisk.pl> <20111024104444.09337fe6@notabene.brown> <201110241223.43362.rjw@sisk.pl>
            <20111025135244.710e43fa@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319528840_3131P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 03:47:20 -0400
Message-ID: <12555.1319528840@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4EA6698D.0031,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319528840_3131P
Content-Type: text/plain; charset=us-ascii

On Tue, 25 Oct 2011 13:52:44 +1100, NeilBrown said:
> On Mon, 24 Oct 2011 12:23:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> > On Monday, October 24, 2011, NeilBrown wrote:
> > > On Sun, 23 Oct 2011 15:16:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > Similarly every system need one process to manage suspend.  It can be my
> > > daemon or your daemon or Alan's daemon but it cannot be 2 or more of them
> > > running at the same time as that doesn't make any more sense than having
> > > systemd and init running at the same time.
> >
> > I agree that it doesn't makes sense.  I don't agree that it implies people
> > won't try to do that.
>
> Does that matter?  If they complain, tell them it isn't a supported
> configuration.

We however *should* design things in such a way that if a second one is started
up, it tosses a nice obvious -EIDIOT error of some sort.

--==_Exmh_1319528840_3131P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpmmIcC3lWbTT17ARApZZAKD0CGbnqUSEmyUTNuANl/LdYX2AAACfWjjX
bo0+En3YcMBrW0+R7ZfHzIM=
=Axmn
-----END PGP SIGNATURE-----

--==_Exmh_1319528840_3131P--

