Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1ARK5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 05:57:16 -0500
Received: from quamquam.org ([88.198.196.3]:42902 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1ARK5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 05:57:15 -0500
Message-ID: <4D357204.3090505@poelzi.org>
Date: Tue, 18 Jan 2011 11:57:08 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
X-Enigmail-Version: 1.1.2
OpenPGP: id=0A7B003D;
	url=http://files.poelzi.org/poelzi.asc
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE2743C3C8693CDC6D1649C32"
X-SA-Exim-Connect-IP: 91.64.130.10
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: poelzi@poelzi.org
Subject: [ANN] ulatencyd 0.3.1
X-SA-Exim-Version: 4.2.1 (built Sat, 07 Nov 2009 20:03:47 +0000)
X-SA-Exim-Scanned: Yes (on quamquam.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE2743C3C8693CDC6D1649C32
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi all,

I'm happy to announce the release of ulatencyd 0.3.1

What is it ?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

ulatencyd is a scriptable daemon which constantly optimises the Linux
kernel for best user experience.
The default configuration tries reduce the latency for a typical desktop
system and protects the system from malicious processes/groups.
With a different configuration all other types of systems can be
adjusted as well.

Website: <https://github.com/poelzi/ulatencyd/>

=95 Ubuntu PPA: <https://launchpad.net/~poelzi/+archive/ulatencyd-stable>=

=95 Latest Release:
<https://github.com/downloads/poelzi/ulatencyd/ulatencyd-0.3.1.tar.gz>


What's new in 0.3 (very short version)?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

=95 X-Server plugin which monitors the active windows and gives more
  priority to the recently active windows.
=95 Full scripted scheduler with flexible configuration that allows easy
  adjustment of the resulting cgroups and parameters.
=95 Protection rules against common cases of memory shortage, also known
  as the swap of death (even without swap).
=95 Scheduler configuration for desktop systems
=95 Fast C core with Lua embedding. Intelligent caching to reduce the
  load on filter rules and scheduler.
=95 Very detailed API for system inspection and adjustment.
=95 Rudimentary Rules for popular Desktop Environments KDE & Gnome


Does it work ?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Yes. Of course it is possible to still cause a swap of death or overload
the system so much, that it starts to get lag. But typical cases get
caught by the current rules. A make -j 50 of the linux kernel
on my dual core machine with 4 GB ram let me still work on the machine
quite well, but a make -j 80 still locks it down for like 4 minutes.
This is most likely because the heavy swapping done on the isolation
groups (their main memory usage is restraint). This may be fixed by
using the blockio subsystem, but this is not used yet. Planned for the
next version.


kind regards
 Daniel Poelzleithner


--------------enigE2743C3C8693CDC6D1649C32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNNXIKAAoJEFYpgV2Roepc2pEP/35aeJw/isjU3v2kYBRcxGEj
FDqw4vJ3WIfSnv/Gnrv0PS/56DOwSlNH1KHtIgjGi8ICWzwQSbk8NuSHQUEd5vXr
XBjQchkLmTHSfK0dC9c1X3NpJzhC23AFHcPhcfNqEk8QX7gUyk8ac8wFqa9TG3eS
w7szX90vzYV/vpCOzGniMTvn01Q1MpZx+SOYgmQYxWVcqRBjqAA+am6i/w7VSy7a
/Kncej+TKS1Xclv9VXXHFDbtaORx8nXpXGrhq6UTfL1fh0y9ibYO6cCm9ysShxTT
q+thZguYAPe8HWEEVEs/kChSkpn+zCAcEL252ySOFSVtAPjQlATqBywJBvIm4Krf
xP/FtOwOwVcHmR5wpVPsLLEzlTAHLfwP7gT8R6ERaQef4UoDyBbgwBjCCMZ6nu4L
+bCeEeAc+qes+6ehEbkD6N2gtzv7zld5QEo5a1uv9FHxLu4OVv6z6+wjK2KdVci5
Ar527vxzH7Q3IclfelzkGDt5Ojgn/20x6yHFLxNfXWvQas+z/w6FTlQFCdgiKnae
3P6ZRbeQuh3VSVt3okrlmx7EcN++FX3R4DDnKONGFL+oPbo/f3K4v4OGj44TZxXh
CEbsVYZbA+5ELlh7fAE3GOKgWTX1WB0KQ2rqou8/7X+X/mYF+CkQybme0MCzICoe
zcnsIhMr/NXG6eK7ITgL
=bosV
-----END PGP SIGNATURE-----

--------------enigE2743C3C8693CDC6D1649C32--
