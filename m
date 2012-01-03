Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2ACR6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:58:17 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36205 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754443Ab2ACR6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:58:14 -0500
X-Sasl-enc: Jq6Z1//OHSVTIviAbQLlAe1IgYrF0VvZfk4gjNzWjKRj 1325613494
Date: Tue, 3 Jan 2012 09:57:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.52
Message-ID: <20120103175717.GA16335@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 2.6.32.52 kernel.

It contains a single bugfix for resume issues that were reported by a
lot of people.  If you didn't have this problem, no need to upgrade.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 kernel/time/clockevents.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 2.6.32.52

Linus Torvalds (1):
      Revert "clockevents: Set noop handler in clockevents_exchange_device()"


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPA0F8AAoJEDjbvchgkmk+zbUQAIjRLuR81oXMMMKBCEwf+tWl
xGjK0JmS63tCjww2FH5dPW8HdxkGG7AXf8jRYs59v1byHaiZi68Fge2q3qk7pt3D
8ZsFV20Amel8me1+BObyUjmcKMUrlfeSV1UnTXr64UWrh/2g8esVtIY7BXbj+rxc
dnl57xgodg2seEY5IeEtyJS9Pbk9b+yFrwpctFigi1qqQYvPEle3o2/NH0AXHtqZ
sWAuuN/fcEnII6gZ6vvT5T5NxHShbfILTfFZR1hTec5wsFZVCItNSEeMpBnGP0qu
9PaJ3YpTccrYBRk1fgD7okqtD3e/n17Z8E3q37ZPYcMhYcLWuMT2C/7KPSttObwe
F/VR/yMAfeEYEOa1Gd7n1VWNaanHY96au7fDBfXFJ0yPT3z5q/u4BJ0Gp7woAX7W
gsxxNXFKq2FU8nW455YOx5IY9I4PoXETwjmy642B8OhfOjuGiPpUK9S4bQrNKXbd
CPgcNq3JNsGce4DdiNP1jaCQeCRpTh/TPyrCmUEJ7peU6UHr2wbJiO+JpsJJRpTi
u8SMxRhJIOyGV3ww/IyN2M7LHTqfrjzjHh6dYSbADvf+tZepF5kjqv6FSJULibqW
t4AkkdQ7rTjXtmOGw86a3dr/9b4J2pqVvlbitobY2eoclIj0tzp2M+u+eYxhQjKY
40mAztdHejLSPHGHSM4u
=4VA1
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
