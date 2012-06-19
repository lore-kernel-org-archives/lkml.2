Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2FSIIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:08:36 -0400
Received: from mail.not-your-server.de ([78.46.182.243]:54670 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2FSIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:08:32 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2012 04:08:32 EDT
Message-ID: <4FE03133.6070606@gentoo.org>
Date: Tue, 19 Jun 2012 09:58:43 +0200
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120607 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Suresh Jayaraman <sjayaraman@suse.com>,
        David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: Re: [PATCH] [RESEND] fs: cachefiles: Add support for large files
 in filesystem caching
References: <4FD5844D.4010900@suse.com> <20120618160408.8d0dd792.akpm@linux-foundation.org> <4FE00DBF.7080405@suse.com> <20120619005214.989e90a8.akpm@linux-foundation.org>
In-Reply-To: <20120619005214.989e90a8.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig73EE0B9A653B5B5B6788F248"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73EE0B9A653B5B5B6788F248
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19/06/12 09:52, Andrew Morton wrote:
> On Tue, 19 Jun 2012 10:57:27 +0530 Suresh Jayaraman <sjayaraman@suse.co=
m> wrote:
>=20
>>> How extensively was this change tested?  Please describe the testing
>>> which was performed?
>>>
>>
>> The original patch was tested by mounting a NFS share with fscache
>> option enabled, do a md5sum on a nfs file larger than 2GB and ensure
>> that the file is getting cached by fscache (watch cache size growing)
>> on x86_64.=20
>=20
> Well it will need a lot more coverage testing than that.  truncate?=20
> expanding truncate?  write, lseek, pwrite, pread(), mmap(MAP_SHARED),
> behavior at the new max file size (what is that?), etc.
>=20

Hello,

I am using this patch since the 2.6.3* linux, while working with files
>4 Gb on a daily bases. This isn't a testsuite, but it worked fine for
me all the time.

How would such testsuite you request look like? Anybody willing to write =
it?

Thanks,
Justin



--------------enig73EE0B9A653B5B5B6788F248
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEUEAREKAAYFAk/gMTMACgkQgAnW8HDreRaSugCY4MhdYsrAjqVHtUGOWUJOm+PC
CQCgnmgAzg9gKt0cMdqPBG31MPOnsIA=
=zpPb
-----END PGP SIGNATURE-----

--------------enig73EE0B9A653B5B5B6788F248--
