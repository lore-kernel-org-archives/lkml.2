Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3ABNqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:46:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43860 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab3ABNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:46:08 -0500
Date: Wed, 2 Jan 2013 13:46:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] vfs: Add missing errno.h inclusion to namei.h
Message-ID: <20130102134606.GE4627@opensource.wolfsonmicro.com>
References: <1357133786-29587-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20130102084205.2320f6b9@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ep0oHQY+/Gbo/zt0"
Content-Disposition: inline
In-Reply-To: <20130102084205.2320f6b9@tlielax.poochiereds.net>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 02, 2013 at 08:42:05AM -0500, Jeff Layton wrote:

> I think Ted and Stephen (cc'ed here) proposed the same patch a week or
> so ago, but I'm not sure why Al hasn't pushed it yet.

Well, a Christmas vacation isn't totally unreasonable...

--ep0oHQY+/Gbo/zt0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5DoXAAoJELSic+t+oim93vkP/2KFmFl77+w0zocIWUHdKotW
HuT4SLzqZhrqLvlGsEZeq86t70CBHT2n+z8tEkkPumAQxVKokoOblyJD4V+d+kik
ILFCoH5nDkXXvm1o+dSSAhssRzxaRvvCuybixBn5Jr7BOyH4LUUhbTefoRU22GwE
k5gAWKlCK25vEz1W8PugM2ooDvPuB6w/+stLnfmAygoTCWZUXYoNfGgLB9Ld+3Is
0SiehlYO3llno1iqJastlUnvD8T7efDwL28ifkQgvOFa6NDBTVNuYiUCbma+vQx6
fFSi1NZ36si1dcapRT+/wYqiH7xX1x6snnOAX3cHcDw2RH7jIQK334eYKCR1SQO7
8Q8/XGyKlyJwQFoaohYHMmiQsUjFuAHUJlcMTTC59wD1JPuTkhPQNZ2uIKzZ+8T3
goVwqzeriXfwBmC9zqqm9/EaY6OgIlcGqZYvswkMg2+XP2hPg74ZaaBOz4MGVYq8
CkUrVGjUqAUVR+EbJj850M55et2ai4yRdqWWsTkLKhbGcKi+FHANOjmmCzC653a9
OEPwlh0Rj5SSxe4Xv5P9E1lzuS2cCdNF8gqwbE9rYM4FkHWKoCY31wIJV3fw14Fp
xWIodEpEnf1gIP+wU4QgM0AVaeaz3er+cSVLnI70voNCINOaG24Fnljf/S6OpFUP
HGaBMIqGpZ+Hd+cIi6vW
=OnJz
-----END PGP SIGNATURE-----

--ep0oHQY+/Gbo/zt0--
