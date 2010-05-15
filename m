Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0EOAtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:49:41 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.42]:45686 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab0EOAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:49:39 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 May 2010 20:49:39 EDT
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.
Date: Fri, 14 May 2010 20:29:33 -0400
User-Agent: KMail/1.9.9
Cc: Alexander Kurz <linux@blala.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com>
In-Reply-To: <20100514190142.GA2505@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1810117.UCjsJxFdU0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005142029.37408.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1810117.UCjsJxFdU0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 14 May 2010, Greg KH wrote:
> Wow.  Is this something that we really want?  That's a lot of new
> Kconfig options, and while it seems like it makes sense, I would like to
> get the comedi developers opinion here.

It doesn't matter to me how granular the Kconfig stuff is.  Personally, the=
=20
only thing I tend to do is disable are the pcmcia drivers as a group on=20
desktop machines.  Also, I noticed in the patch it includes the 8255=20
module as part of the PCI and ISA groups, but not PCMCIA.  But it is used=20
by some of the PCMCIA drivers as well.


--nextPart1810117.UCjsJxFdU0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBL7eru5vihyNWuA4URAiXVAKCQUVUQtZs3KOdYMZEZgh58OJBCJQCeKSDS
bIWkeKFvzdTrbInyXLQSooA=
=DZmA
-----END PGP SIGNATURE-----

--nextPart1810117.UCjsJxFdU0--
