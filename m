Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2HSXQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 19:16:32 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:57073 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2HSXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 19:16:29 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2012 19:16:29 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQCALdwMVBbdWObgWdsb2JhbABEDroxIgEBFiYngiABAQQBeAEFCwsYCRYPCQMCAQIBRQYBCQMBBwIXh2wKB7dPiyCGfQOOW4EghVWSOTyBVw
X-IronPort-AV: E=Sophos;i="4.77,795,1336341600"; 
   d="asc'?scan'208";a="942547162"
Message-ID: <5031716C.1060003@igalia.com>
Date: Mon, 20 Aug 2012 01:06:20 +0200
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
Organization: Igalia S.L.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Dan Luedtke <mail@danrl.de>,
        Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
References: <1345333117-2826-1-git-send-email-mail@danrl.de> <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com> <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com> <1345383264.4441.56.camel@tunafish> <20120819120254.GA2369@pompeji.miese-zwerge.org> <1345390432.2716.34.camel@tunafish> <20120819210455.GA9208@thunk.org>
In-Reply-To: <20120819210455.GA9208@thunk.org>
X-Enigmail-Version: 1.4.1
OpenPGP: id=6B95F882;
	url=http://key.neutrino.es
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigA34A7FBBDA3AE1A5B5F2072A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA34A7FBBDA3AE1A5B5F2072A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19/08/12 23:04, Theodore Ts'o wrote:
>> There is a small niche which LanyFS tries to fit in. It is for those w=
ho
>> > do not want to bother about how to use a fs when they are in a hurry=
 or
>> > when they just want to listen to music in the car.  It is for the
>> > it-must-be-easy-enough-for-my-gradma fraction.=20
> Music doesn't require > 4GB files, and there are plenty of very easy
> to use solutions that utilize streaming over the network.  That is
> *always* going to be easier than figuring out ahead of time which
> files you want, and then manually copying them onto a thumb drive, and
> then taking the thumb drive to the car....  Somehow I can't quite
> imagine your grandma manually copying files over using LanyFS.  :-)
>=20


Microsoft is pushing exFAT [1] as the successor of FAT32 for this kind
of use cases. The problem is that exFAT is full of patents and they
require you to purchase a license for use.

I think that this LanyFS could be a great free alternative to exFAT when
the time of 4+GB-for-a-movie will became the norm.

The problem will be that IMHO Microsoft won't be interested in
implementing this FS on their OS despite of the license since their
interest is to push exFAT.


> I also seriously question the niche of people who want to use a thumb
> drive to transfer > 4GB files.  Try it sometime and see what a painful
> user experience it is....

Think for example on consumer devices, for example on most moderns TV
you can plug a USB memory disk with videos and play them.

And videos are getting bigger and bigger. Many FullHD movies that you
can download or record are bigger than 4GB, and in a few years this will
be the norm.

And I doubt that the majority of this consumer devices are able to read
nothing more than FAT32 file-systems, so the 4GB limit is a big problem.
And here is where Microsoft is pushing their exFAT FS since it allows
working with 4GB+ files without the NTFS overhead.



As a side note, it would be possible to write a driver for exFAT and get
it merged upstream on the Linux Kernel without "breaking any law"?
Goggling I found an attempt to write such driver but seems that never
got merged:  https://lkml.org/lkml/2009/2/8/24


Regards!
--------

[1] http://en.wikipedia.org/wiki/ExFAT


--------------enigA34A7FBBDA3AE1A5B5F2072A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJQMXF0AAoJEJZQic5rlfiCvV8P/1P0AR8KrH6FYA0hHb/iWEkj
Jh9ECp8tw9E+6OziDzFy/mteY3UsQuXgpwwRybwZjeFnyQhRrJl1GkNOiEYRdr97
iBdpvxSQztYJxS7aeBwMBW3I7zM1PTIgviB+HHUj/vxQ73UCkRi/W+5YmMwTa7iG
FypeF5MysW8S2+8IfPUNFzo1oPLZcE6EUKaCS31D+pATvhM7hVCMrGwsS5H2qix7
hhwPTWrmNqffBChBKeCNEbqwWQdF6vubHveSTAy62Qa12TtWtaMPa7ScPnIWRgS5
L6VF0Cqa/iCv/H5ZkjZiX1UDjoauQ5EMGKTTxukvPfE7m7InVrJ23Jiv4TWX6kCe
Mul1Pu/iy+OVVQyB/xOMO4//VWg3G6eQ0XvpHSf55QRjO3lI2EdldQb8fGklR7VJ
wb19GtYRUD7ezAHiXHIG6mrCSbCpii0tUu+kvQ3GTcBXv7LhzeiQLjAxaGACg04V
1MEomKmBEjfNlQTKAyQnfkazlZLsnYKm6Uvt/FDFAD2nQPoyGAGh/m1EQiF2iuda
TXQCREbksdCXw9Tf3lqgs+h/aja2GHzHPUR5J0RpP88+qipx6G0MCliYMn89Zdxy
gQHY7q5CE7iZLDjY5EUQMqGkDGhoBRvpB42nDh1RS+Tn9QX3iaGFlAOo1J7qwYcX
Dy5bhkTvHVSFMgvSDDZ+
=zjAv
-----END PGP SIGNATURE-----

--------------enigA34A7FBBDA3AE1A5B5F2072A--
