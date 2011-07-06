Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1GFJxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:53:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36392 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1GFJxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:53:46 -0400
Date: Wed, 6 Jul 2011 12:53:10 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: `pvmove stuck' in RH bugzilla
Message-ID: <20110706095310.GA3225@swordfish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I think we just trapped into the same trouble with pvmove as described in=
=20

https://bugzilla.redhat.com/show_bug.cgi?id=3D602516
https://bugzilla.redhat.com/show_bug.cgi?id=3D706036
etc.

Comment says, that
> I found a series of problems with pvmove which I have fixed in the upstre=
am
> repository.  However, I would like to wait some time to see that no unint=
ended
> side-effects show up before seeing the change back-ported to RHEL.  An au=
dit
> for similar bugs found a problem in lvremove, which I have also fixed.=20
> lvconvert still needs to be audited.


Alasdair, could you please point are those patches in vanilla kernel=20
(3.0-rc*) or linux-next, or some RH internal tree?=20
This is not critical, though I'd like to try out patches.


Thanks,
	Sergey

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk4UMIYACgkQfKHnntdSXjSrNQQA1VUekaYX7C1n1u/fEuWFwNIk
oUxXXvwja8ICVuS7/3Ofy1/ahtDh/YSxj7pN91geIRPgP1fMkxepl52R5Qvwxuky
+dcT+qTfihWEzaho/OH3YgpzJ6/3+LC4EszPnjqfHBCNR831LbnlvqeuOOX4LTlW
XO7kxlGxwWmtqWslpaM=
=iwTa
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
