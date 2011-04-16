Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1DPIhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:37:36 -0400
Received: from wnohang.net ([178.79.154.173]:59800 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1DPIhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:37:35 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 7762134870
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 88A483486D
Date: Sat, 16 Apr 2011 14:07:30 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for unintialized variables
Message-ID: <20110416083730.GA5114@Xye>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hi,
I have attached (as reply) two patches to one of the drivers in led
subsytem. The return value was not being checked before proceeding
leading to uninitialized values being passed in few places. In the
second patch, I am a bit unclear of the logic in the function being
patched. So modify it if required.
--------------------------
Raghavendra Prabhu
GPG Id : D72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNqVVKAAoJEKYW3KHXK+l3Vv8H/3BmvDOHVXibP/6tZ7xThR5Z
EtlJPsemO73c1yZdXWXB1A5AVP78yhkou5FTuLDojT8/FQdIzUxb6n57Z8R5l5Ay
NefDXCWeQgJdCVYWE8RumIpN1Fe5AO6aAdBknHuUAr0eXOCbF8bzJxi3f7gQh2g4
PfK/xkISrDoaVUMj77MJpCPi1gx47OmGNOpGvyR7Fu2OmJNJPtGTMI8eFbZWEI7O
W8CpmlqsvZwWwLdVL/f8GwqD60W65N3k9GJQS2AZmnJHNSZ4rmtivz6WV+ynZark
Zp7acn+yTotWnrwHWmgFqpeUysFYl8mzYX+LyjXqyGvduGYOqlCLQp1HP3tjzoo=
=9SNM
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
