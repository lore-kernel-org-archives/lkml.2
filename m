Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab1JCWCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:02:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53132 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932667Ab1JCWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:02:34 -0400
X-Sasl-enc: VDP7umcXeJcgIHFqVemo32bJhrSYp/S9IBoc9f5RgpF3 1317679353
Date: Mon, 3 Oct 2011 15:02:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: movement of my usb / staging / tty / driver-core trees
Message-ID: <20111003220219.GA9913@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stephen,

Now that git.kernel.org is back up, I've moved my linux-next git trees
to a different name, dropping the "2.6" suffix on them.

So, they are now at:

 USB:		git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
 staging:	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
 driver-core:	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
 TTY:		git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git

All of the branch names are the same as before, and they are now all up
to date with the local copy of my trees that I kept while kernel.org was
down.

If you have any problems with them, please let me know.  I'll be
updating the MAINTAINERS file for 3.2 to update the locations to keep
everything in sync.

thanks,

greg k-h

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk6KMOsACgkQMUfUDdst+ylhcQCcCoqtNHfZqXV1hAcRRrC7XZ1L
UZgAn1ptZccr2xpIMOpkvQgRc+WD1m7F
=+ZTC
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
