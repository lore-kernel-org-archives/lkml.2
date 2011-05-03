Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1ECSDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:03:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58644 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1ECSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:03:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
In-Reply-To: Your message of "Tue, 03 May 2011 19:14:18 +0200."
             <201105031914.18160.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <201105030044.51661.rjw@sisk.pl> <201105031302.08910.rjw@sisk.pl> <15997.1304437643@localhost>
            <201105031914.18160.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304445799_4857P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 May 2011 14:03:19 -0400
Message-ID: <22088.1304445799@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DC04367.0141,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304445799_4857P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 May 2011 19:14:18 +0200, you said:
> On Tuesday, May 03, 2011, Valdis.Kletnieks@vt.edu wrote:
> > > It's useful, but I'd rather do
> > >
> > >  		dev_info(device, "firmware: %s will not be loaded\n", name);
> >
> > That works too.  :)
> >
> > > OK, updated patch is appended.
> >
> > Looks good to me.
>
> May I take that as an ACK?

Feel free to stick either an Acked-By: or Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
on the version with dev_err.  I'm not sure which one applies.




--==_Exmh_1304445799_4857P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwENncC3lWbTT17ARAmWkAKCvRpIHR2fVPGRtvyrkx+ezVrTGVACgptT+
auHJQkxBf6PPu24tyeEOmIU=
=XNPQ
-----END PGP SIGNATURE-----

--==_Exmh_1304445799_4857P--

