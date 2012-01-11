Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2AKJDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:03:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47470 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2AKJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:03:26 -0500
Date: Wed, 11 Jan 2012 12:04:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        Haogang Chen <haogangchen@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: aacraid question: is maximum_num_containers supposed to be
 minimum?
Message-ID: <20120111090430.GE16258@mwanda>
References: <20120111082842.GA31452@elgon.mountain>
 <8654A042-17CA-4C02-8F34-554ED55B34F4@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
In-Reply-To: <8654A042-17CA-4C02-8F34-554ED55B34F4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F0D505C.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 11, 2012 at 03:38:55AM -0500, Xi Wang wrote:
> On Jan 11, 2012, at 3:28 AM, Dan Carpenter wrote:
> > MAXIMUM_NUM_CONTAINERS is consistently used as a minimum not a maximum
> > so I was wondering what was up with that?  This is ancient code that
> > predates git.
>=20
> Check out some early discussion. ;-)
>=20
> https://lkml.org/lkml/2011/12/3/85

Heh.  That's weird that we were both looking at the same code so
many years down the line.

Still Haogang is assuming that MAXIMUM_NUM_CONTAINERS is supposed to
be a minimum instead of it just being used that way by mistake.
Mark is more familiar with code and thought it was supposed to be a
maximum.

regards,
dan carpenter

--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPDVCeAAoJEOnZkXI/YHqRfYYP/RNZn9IWSu77NqnnV4sKi/Yc
poolk1upL8J46z3tK5cOyuxib6DbtL6AR+XAFGMVXns1Svu2K9Fq0bxHJd0F/nQs
grBfgCSPARpeOYkx6OczDyV81Zsjv0sE+3+D517S7qTpROXFWdf9jdlpc02PRmhY
VG9foy9VGQzAMknmNmYB4Jb3CvxrHralJZh5N10UqYfuQ9Ka3cYBs7/E3pdOKHk9
jnYtSrdAdewCAJ8vMmp7KW3Gv1uIbCy9wWyJ+pSNoAMkYF8TxlF3HqF7T+ogcsOY
/mrKVsNujB8SkAn75APygndX3Qq1Wr8sh4eZdhoj6+8zc2TvZG5CaHNqV4Y5EyMQ
Glh1oetkmMGHrLErZdSji1zA4c51OYzWnuKC/LHZjU89zRDADSUNVRJ2dWdPFQmv
kQeY8lJZHcTLEgRNChs4HzMZ0lNIaNkvrKdbT6cZNJ9a0qT/KgiqlOVRBYl5Q4G3
1H3ComuDn7TcKWOjU14I5lKgJ2wOrrfTsgoTpGJGwjzkvgaMvxiCNS7LCJTHwS3B
8RGBZRIj45FvMStS4G+kSWNhrY9GQFkwb9zU93olkMAJqWhuI+UKvl2KxRFcYH/2
ET1uEp6tRV+kK28CjzaNKKbqyh62OTbbF3uOBiVWqXY0GbH6dO33REZn/paLPtWB
CqZcxSHt483C4mdpGiQT
=tKGx
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--
