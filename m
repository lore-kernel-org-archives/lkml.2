Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1AHNqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 08:46:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59222 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab1AHNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 08:45:58 -0500
Date: Sun, 9 Jan 2011 00:45:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Message-Id: <20110109004539.5bf33510.sfr@canb.auug.org.au>
In-Reply-To: <20110108130427.GA25461@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org>
	<20110108130427.GA25461@merkur.ravnborg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__9_Jan_2011_00_45_39_+1100_pqCfy2+KC9Q3YZl0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__9_Jan_2011_00_45_39_+1100_pqCfy2+KC9Q3YZl0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Sat, 8 Jan 2011 14:04:27 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> -LINUXINCLUDE    :=3D -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
> +LINUXINCLUDE    :=3D -I$(srctree)/arch/$(hdr-arch)/include \
> +                   -Iarch/$(hrd-arch)/include/generated -Iinclude \
                               ^^^
hdr-arch?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__9_Jan_2011_00_45_39_+1100_pqCfy2+KC9Q3YZl0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNKGqDAAoJEDMEi1NhKgbsK7cIAIpyFKyokfnp2U89n3rW4/Aa
u7V4p3ZMLn62soxpGh1rGXcxotRkqDZrqYlCbPjX0Gu2zXX02sCLl8EXqV6nZbpS
ArFbEatYNward2tNfGbC+5oDFk+cjuRytHXc/JfqpejZwDhCwe/OeP9ZQl/P+jB1
2JQDA/a1gVB8ilzLvyBoJClRcd9X0R6qArn+JjiZetJNEPt0FhtZ0s384FTLs387
63v0WKpn+QS7AphuppuFjVqMxTitXQoofYpiaBYgE1J5NViYbErLUgkkoIOGmYkl
E63rwMJ0fkdFIQYHJppNMz/FXEsZmXBRy9xaizNMckWl7EDU7qGzK4IKU218H+U=
=5zls
-----END PGP SIGNATURE-----

--Signature=_Sun__9_Jan_2011_00_45_39_+1100_pqCfy2+KC9Q3YZl0--
