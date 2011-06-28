Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1F1ARS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:17:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34968 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab1F1AQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:16:17 -0400
Date: Tue, 28 Jun 2011 10:16:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging related)
Message-Id: <20110628101604.3c039244.sfr@canb.auug.org.au>
In-Reply-To: <20110627214547.GA10889@kroah.com>
References: <20110609184127.GA2760@kroah.com>
	<20110609192243.GA3980@kroah.com>
	<20110610160548.529797c7.sfr@canb.auug.org.au>
	<20110610160938.cd01c408.sfr@canb.auug.org.au>
	<20110610223423.GB15868@kroah.com>
	<20110615142155.bd538b73.sfr@canb.auug.org.au>
	<20110616191448.GA10255@kroah.com>
	<20110623103503.cd9e7e70.sfr@canb.auug.org.au>
	<20110623215115.GB10969@kroah.com>
	<20110624100005.f9f59ddf.sfr@canb.auug.org.au>
	<20110627214547.GA10889@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Jun_2011_10_16_04_+1000_MYzcnS_Rl6pzfNHu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jun_2011_10_16_04_+1000_MYzcnS_Rl6pzfNHu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 27 Jun 2011 14:45:47 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jun 24, 2011 at 10:00:05AM +1000, Stephen Rothwell wrote:
> >=20
> > Thanks.  I will use Ralf's (arch restricting) patch until you come up
> > with something better.
>=20
> That's good, but it doesn't fix the root problem here.  I've now fixed
> this up in the staging-linus branch.

OK, I have removed my copy of Ralf's patch.

> You shouldn't have any more build breakages in the drivers/staging/*
> tree now as I am pretty sure I've fixed all reported issues.  If not,
> please let me know.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Jun_2011_10_16_04_+1000_MYzcnS_Rl6pzfNHu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCR1EAAoJEDMEi1NhKgbsODYH/iaVEe6tqInPyCEULwoEZTkK
1ZQpO9+HS+OvKsjprSFumDt7ZFSLBZMPu4Urx+LFqD2ByupU3YhT0y3LmcR2t/UG
tYaXXJcQtJBkDjpjeNJhWBUGKMkxYoiqOsxaZcu6fFOf5jfYTAAHyJL8XPdmio65
UwOWgqxKmWnLM92xGSl3W6wp6tGxp9gNao1CPPYZi94l2ag1HB8bhWq44aEwAX5C
zNUSd4VGnuIkrjmIt2zGKdPU54agwGRkRdhXm+o7Re4fSjpss5mHhfyzJMtnU8o3
mq84SYfIQGtgFMxiJBsX4+A5IOq3vc2b5eOBVneJrwviO/X12wveeNhJ3G/sElk=
=9+rO
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jun_2011_10_16_04_+1000_MYzcnS_Rl6pzfNHu--
