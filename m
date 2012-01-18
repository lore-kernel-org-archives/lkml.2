Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2ARSyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:54:08 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24107 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab2ARSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:54:06 -0500
Date: Wed, 18 Jan 2012 21:54:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pradheep Shrinivasan <pradheep.sh@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Cc: greg@kroah.com, devel@linuxdriverproject.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
Message-ID: <20120118185457.GH3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
 <20120118065620.GE3294@mwanda>
 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="poemUeGtc2GQvHuH"
Content-Disposition: inline
In-Reply-To: <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F171547.0067,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--poemUeGtc2GQvHuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 18, 2012 at 11:38:34PM +0530, Pradheep Shrinivasan wrote:
>> > > -#define PMEM_IOCTL_MAGIC 'p'
> > > +#define PMEM_IOCTL_MAGIC ('p')
> >
> > You don't need parenthesis here.  Did checkpatch really complain
> > about this?
>
> Yes the check patch does complain about the parenthesis.
>=20
> pradheep@ubuntu:~/linux-next/
> linux-next/drivers/staging/android$ checkpatch android_pmem.h
> android_pmem.h:10: ERROR: trailing whitespace
> android_pmem.h:19: ERROR: Macros with complex values should be enclosed in
> parenthesis

That seems like a bug in checkpatch.pl.  It's hard to imagine less
complex macro than:  #define PMEM_IOCTL_MAGIC 'p'

Perhaps if the check looked for one of these characters: */+-=3D<>|&

regards,
dan carpenter


--poemUeGtc2GQvHuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPFxWAAAoJEOnZkXI/YHqR+P8P/3C5vkg+KnU3SWvJWdX7Jpfu
Usaaqq44lnkS4SCjT9xeD82S/BWu4xEd1xLq0UbKswT5vtY5Pdf++aDJUSCe//nR
HuH6yQJ4t+NkL2tEqnlZHcX+KYo3kJ85Up2EtqMGWeSClb+XKNUDHw1+oMZ/0BLs
RgOgnw44frda4h7U78yVKVZpQ3mXGbs8sZvwknfPsqNMs3+CWObcsh7Dblsgo+lB
LB92AYnthbEaZoBjmeDVOPdXNNaibF9+uX/b2gBpWexTbJpFeRsY2g425xw4KWL9
ZkzhJ/EWqqSZDi8rnMuoyUKnxHdD6+2Uqg1ul9XTF/0LlE59gJQ8UcG3jdms8trv
ulmEjjzD5aRm1aiBH7++0M4j8c9ic8wJA50fqw9SeTIUALEESnNOZaYrORfkRw7P
wTcXjZPbkwEEjPPhKR0gGG8A1yUsUsG/noSHrmTjk7Fvmwewu/DTy16miiLE/0ic
I0lFFpqchX/CNr1dWpH3rQQa31cWMqDYf9OGN4I9A+bY/rNFXwSoRzmFuzK2UXSS
qpK5FHhoQEWk3rH1UMaRtamSyHY4hkvY3vjuKrzAoMt9euY/guOkTDtPRKbge2MO
LHWCAb8f/tBILFYiATJsDY9ToSy8wvwpmIyVYV/dsbmawNHS2zyZRPP4sAwEMGOY
LlCXRN4DIQZDseeXOWyr
=D+sy
-----END PGP SIGNATURE-----

--poemUeGtc2GQvHuH--
