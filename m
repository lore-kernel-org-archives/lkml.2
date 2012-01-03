Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2ACTb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:31:56 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51775 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab2ACTby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:31:54 -0500
X-Sasl-enc: WfD8alPoKYnp6y3ygrSSqZq00nkJBBr3bRperi1QBnjK 1325619113
Date: Tue, 3 Jan 2012 11:29:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.15
Message-ID: <20120103192936.GA1724@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.14 kernel.

It contains a single bugfix for resume issues that were reported by a
lot of people.  If you didn't have this problem, no need to upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 kernel/time/clockevents.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 3.0.15

Linus Torvalds (1):
      Revert "clockevents: Set noop handler in clockevents_exchange_device()"


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPA1cgAAoJEDjbvchgkmk+m8AP/RE5XJVjEhP1u9ZJjQVYLxQx
d7mu7zPyfK7QAeKPd6EdAAGICkQdi7aQ3szJhiFz3Gq+j1TLs8jGHl48wLkhy8C0
bZKfn+3KJnEA3mP1EOez426vxvl/T1avnuobvPiyRWkQKIY6M0mSsDXsMp6Zvyts
09a4kKT7PGh2EyXuDYws/14WSDB8G2dh2PQEmEizsK/TjMKQZ9n0yYq4qyP/yJHR
ce8ZG7yvFkjVoc1QV8NZOuenSLloG7kBmPSdU/VVTvPgea/efyv1aXP/zi8qDn4H
XbO5wdgWuK0E0ApGgSvQzZrTQMarhNtFEe9L9dndS0kd4TvEu+p2YnTQOQDJuH13
JPmyerbCytljREDHKogOP5IROtrfYC+pTKvqGlrxo/st60XshzkIjdJhvZvimbWA
gUStHpsmcS6lj0F4py37G958aYznxwAPRQcnjeDKBArRPInO9xqaL+QftFaI7qlU
1mrc8YczUAioWiOVQHE8xV/iwVG6wbeGzUINcUYMhz2DpCDTv2Yc2d94B9dh578v
38IMYTge7Uypy3TathEgKW3W8KVzYdMhrNKG/QVAwaBR3CxrVDmbnyDnId2UU3Gp
cMAOQv4xiOipNy/+pyPGqD+/ZHkv6iir1Hp4KQRN8HNm8LUw5rFnTPadBRfz1LnQ
oZRvIZD48jL+X/e/lq8O
=gK+v
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
