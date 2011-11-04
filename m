Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1KDVAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:00:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47617 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1KDVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:00:43 -0400
Date: Sat, 5 Nov 2011 00:00:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [050/107] block: check for proper length of iov entries earlier
 in blk_rq_map_user_iov()
Message-ID: <20111104210055.GK4751@mwanda>
References: <20111102221600.GA26650@kroah.com>
 <20111102221454.703920975@clark.kroah.org>
 <1320420256.3079.172.camel@deadeye>
 <20111104171425.GA4893@suse.de>
 <20111104190616.GB3366@decadent.org.uk>
 <20111104202806.GA9715@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/rDaUNvWv5XYRSKj"
Content-Disposition: inline
In-Reply-To: <20111104202806.GA9715@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EB45264.0068,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/rDaUNvWv5XYRSKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 04, 2011 at 01:28:06PM -0700, Greg KH wrote:
> Doesn't this still fix one issue here, just not both of them described,
> right?

Not really.

We've got a list from 0 - 100.  We should be checking them all.
If number 50 is unaligned in the old version we would check 0 - 50,
but with this patch applied we check from 0 to 51.

regards,
dan carpenter

--/rDaUNvWv5XYRSKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOtFKGAAoJEOnZkXI/YHqRAx4P/1/OEv6LVTQbdxBp9ApTQ7gL
KSJCvGMxMZ/LerD9QQvfrAdx6ZI8soIsh1z3FdMDVFRyzd2JbCdUXIA03bVVexZn
ajESzGiNaKhvewHdnW7d3J1B/k6L77rzRE2fyLqJGYjh2b87Aby0EyrfmyE77+yG
CHhXw8sZjvWVGk4gu27a5pTuCzMxj9vvzy6081TmuAJLnDOmjWwTtBiTinO/sljE
+edzAx3tmrJmbA2BWAaDgLq7VnYT3xjtVJMGrHxnMgT52uL4Kbgvky/hn9cBz/Pr
jvI5wOvLmKsn90i/7toJlOHqsDCmwTlBLO3026YJAFDtAgUSzIf8BZXbyF0nbWhA
jigfDfkYLoLYaoqGeRZb0L6wTHo7qeZCYNBj4gye8Bjt1hbfRg43tB/zV+F7luaf
D9A5bqRLjpfhPfngSHb0A8pObHvQJQRA+RPyMrRVkSjJqMDiQCYKhASMZY+38D/f
GVY6xCkZbCFVLQ7Bb+eJLm9q/YyfTwx4DC4WLbLM+HKf8uCJArO7yt5iejcICyS/
khQqnH27z/KSXYl2wqJHXs+g1a6MeY2gfOyZBAoMo7cQEK8mUMcYc3/0GVQA01iK
1Ei3FXwlu+HYyElJHyeYFE5ZyyqDdwvUO05W2yZLBLW2jqSNhsb39N28aU0Wjccg
nK4HYCQ+gtP9cpCLL8U/
=Fdt7
-----END PGP SIGNATURE-----

--/rDaUNvWv5XYRSKj--
