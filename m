Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1K1X02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:26:28 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47588 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab1K1X0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:26:25 -0500
X-Sasl-enc: DZvhqMgKTDe2Ku1/z7CK0G95dz7cHVjLTzFUknWmtZQu 1322522784
Date: Tue, 29 Nov 2011 08:25:44 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.1.4
Message-ID: <20111128232544.GA21133@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.1.4 kernel.

It reverts a USB patch that was broken in the 3.1.3 release.  If you
don't have USB isochronous devices (i.e. webcam, audio, or other
streaming devices), you don't need to upgrade.

The updated 3.1.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.1.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 drivers/usb/host/ehci-sched.c |   15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

Greg Kroah-Hartman (2):
      Revert "USB: EHCI: fix HUB TT scheduling issue with iso transfer"
      Linux 3.1.4


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO1Bh4AAoJEDjbvchgkmk++nMQAJ1DwGDYqqkTK9oVXDeVXqcJ
dNghF1AbEx2qDqVjTy0CkM8jx+JKxqdVzIqyd0kHZwPSAP2wUMzy1F3/sIzOhvgB
RZt4f0TMG860POfKCYrmziaOP9iqeBNcqsqHdTkdJHlpRMo/IMi70DKEyvHYr5uX
oK4pMJt3Cfhdmp60YC39nhZHZvMoNdD/pSQBz2xxWdgzcXy9YCO2T64xeU+R9uwZ
dkaDLviiPyTfsVQsVwfQF68lxbRKEJA0f7lHPSnSrgzOv+GMrzZHrP2OoDqoVZwG
5wYJXUsG0sBzhfUL3CKu3rQXeVmn+YzSrQYJrksjIVl9AZoouzRnJtvc27VYdckD
DZj3t9Wq98YBuxrxn7bxBCvkl9o9enl4Kb9bXKHXCJCjtKR4MP1W2ksqoMFfzrSH
oNGP57orT4jP28VUzqnHKJU4I6tOiR4RRB6nmHelYFISHDKqRWbdDzD7ZXyce5R5
8n7YTLZe1+4g78HzLITw3KFkAllk4DVltxTPi7TOHL8MseA8FN2/nuOPhmQ4iaeM
ZfGexzAwt0SZLHmo7ziBVui18aSMhR9JsH5mrOBk9a0OqtvWxifseOchzlUeBfzE
uNvrJlRV81cAvW2yGM2Vz6UwVvPY+4dQYFHJLbvSolawIuQHEFbEX/qv92eIpnX9
12lD6HyvoYrUtMUG27O+
=pYBD
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
