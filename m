Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2LVVdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 16:33:16 -0500
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:52020
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 16:33:14 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2012 16:33:14 EST
Date: Sat, 22 Dec 2012 14:23:24 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: linux-kernel@vger.kernel.org
Subject: ALSA: Conexant CX20585 (thinkpad t510) speaker powersave regression
Message-ID: <20121222142324.73586307@jelerak.scrye.com>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BVzIUtwM8a0.7BCgYrv9jaN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BVzIUtwM8a0.7BCgYrv9jaN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Greetings.=20

I've got an issue with sound on my t510. It started in the late 3.4.x
kernels. Sound works on boot and for 5-10min after, then the speakers
stop working at all.=20

I posted a while back on the alsa-users list, and someone else had the
same issue:=20

http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg28769.html

It seems that the speakers(?) are getting moved to state D3 and turning
off. You can manually get it to come back for a few minutes by using
hda-verb to move it back to D0:=20

hda-verb /dev/snd/hwC0D0 0x1f SET_POWER_STATE 0

http://www.alsa-project.org/db/?f=3Dfd5ca157b2e76942df5ce2f0ae1a2817f3f08afd
is my alsa-info.=20

I'd file a bug on the alsa bug tracker, but it still seems to be down
(for many months now?). No response on alsa-users, so now that I have a
bit of time, I am posting here in hopes someone can look. ;)=20

Happy to provide more info or try things.=20

kevin

--Sig_/BVzIUtwM8a0.7BCgYrv9jaN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ1iTPAAoJEEs3sNgP+7teP7kQAJV/L7VxhlrQhN2iHXtefqwO
xWcMgO4+MLzf37wBS7aKoFO5QxdmfpxgY0fyPZ0hZq4XHCRCY/FQTFZzdKMP8SOA
+1T5RWYbN8s3INL94zqXVwESHQyAguD6N4bLeGvmpb3iQHhkNLlLrEstJ0W6bXGS
qd19CHm3Fm3iULnJ777LrLoE+f3bmocAwvyveE5r/tkn6jVQ4+oh7awQeWRYWNWP
7m6fuukpKzyZATSCDkvQjRQm9PLUwwt5Vw/S6fp2eUaNx1QugxLCk4vhHmcBRPH9
VAvtskzjQRK5hhCGtJzMJGSO6MTDAX7O1InyXQcl7F0LGyZyrddArL1aE3xk+rpE
hEhVe7ABlLl5y5O2NRdeoLOo+NATdLDgdncE1QEkeBS43WUNUz9UXSoMIX3a/XgV
cklm9Q56NVdturUKb322rfMl91dACZQfBiNRoRgZFsIvLRxjgRD3IsOPS/gtehLx
xk3XL18fXfF93Cx2lpG7P1jPyb6Ew2GsSbhXmz4Y7iWkhGEmzOJxeF0vKFAewdKR
ob7Je2tnXz7k1bjM5QN46MpebZcY+gfQ8fTOfTFrRSsJpFtgc7kKiD3x7cZHyP0Q
iHc3d9jWo9QsZO25Y9QiF7EvN5/xY4XqeuPYuZqO9c+6igwWeYSwXNCo/ugaHick
1WRHaoMtMC7ivMKdN8Uk
=z1/O
-----END PGP SIGNATURE-----

--Sig_/BVzIUtwM8a0.7BCgYrv9jaN--
