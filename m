Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab1EIFYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:24:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1EIFYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:24:00 -0400
Date: Mon, 9 May 2011 14:58:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Anton Guda <atu@dmeti.dp.ua>
Subject: linux-next: build failure after merge of the final tree
 (driver-core tree related)
Message-Id: <20110509145854.9e6d8806.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_May_2011_14_58_54_+1000_Y8qoS8lreJdC9EHW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_May_2011_14_58_54_+1000_Y8qoS8lreJdC9EHW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allnoconfig)
failed like this:

kernel/sys.c: In function 'kernel_restart_prepare':
kernel/sys.c:317: error: implicit declaration of function 'usermodehelper_d=
isable'

Caused by commit b50fa7c8077c ("reboot: disable usermodehelper to prevent
fs access").  See Rule 1 in Documentation/SubmitChecklist.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_May_2011_14_58_54_+1000_Y8qoS8lreJdC9EHW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNx3SOAAoJEDMEi1NhKgbsb08H+wa+zoNsiEu54T5XV4fkOaP3
yTZpLc7V1ufJHUNp3FclU4nOeOSJ2q6uaGM7Ih6/LbEmasPon9YQULY5ZG7ZdPmx
4EEkeu8Bj9eA7Q7KK6fwUf2/afPi0X1khWHZbpPCpd8ridExluERcWAo6AwpJVTA
VJCqN1WNi8Agf67ncYx4gIp1NGFrrNUN94lfdz8b9ABiPM+YDZZJ9bblrYsrKYyV
6DUwPISWrZlMsI4mV1u7TWgDyh8G2gzxoZILQoX/dd9RRpgGQTsNghh9q1pWK1Ql
qSqinZMx1PcRpo7j5l0BO82xlsELLUZd/MKEPRPXOcxTBiiQjyQhj6DfLD7OZVY=
=DN31
-----END PGP SIGNATURE-----

--Signature=_Mon__9_May_2011_14_58_54_+1000_Y8qoS8lreJdC9EHW--
