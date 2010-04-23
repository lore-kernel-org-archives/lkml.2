Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0DWSFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:05:08 -0400
Received: from deliverator1.gatech.edu ([130.207.165.161]:41527 "EHLO
	deliverator1.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab0DWSFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:05:04 -0400
X-Greylist: delayed 79803 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 14:05:03 EDT
Date: Fri, 23 Apr 2010 14:04:52 -0400
From: Evan McClain <evan.mcclain@gatech.edu>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [051/197] backlight: mbp_nvidia_bl - add five
 more MacBook variants
Message-ID: <20100423180452.GA3112@macbook.site>
References: <20100422191857.GA13268@kroah.com>
 <20100422190911.935042749@kvm.kroah.org>
 <20100422195413.GA10849@macbook.site>
 <20100423160227.GB8048@suse.de>
 <20100423164945.GA21696@macbook.site>
 <20100423170542.GA21977@macbook.site>
 <20100423171102.GB14832@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20100423171102.GB14832@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 23, 2010 at 07:11:02PM +0200, Willy Tarreau wrote:
> I'm not sure I understand the implications either. The real question in
> my opinion is : is it better to keep this patch, to delay it or to drop
> it ?

I'm afraid I'm not familiar with this whole process, but if the
intention of the stable review is to only include perfectly correct
code, I would suggest delaying until Steffen R=F6cker's patch could be
included too.

As my patch currently stands, it will add support for only four of the=20
claimed five MacBook models. Unless some other machine reports a product=20
name of MacBook1,1 and a vendor of Apple Inc. and doesn't use an intel=20
graphics card there should be no real issues with the patch as it stands=20
other than claiming to support MacBook1,1.

--=20
Evan McClain
Aerospace Engineering
Graduate Student Senator  .
evan.mcclain@gatech.edu  ..:

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iHwEABECADwFAkvR4UQ1FIAAAAAAFQAXcGthLWFkZHJlc3NAZ251cGcub3JnZXZh
bi5tY2NsYWluQGdhdGVjaC5lZHUACgkQvbxY5xzjycDFSgCeIiBkR5iGj9rOOE3O
d8evMB2lNxEAnifa17gIjXlTUE5Af1HodB5tvX4G
=BlGT
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
