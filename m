Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2DKCLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 22:11:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49574 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2DKCLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 22:11:09 -0400
Date: Wed, 11 Apr 2012 12:10:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>, stable@kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20120411121058.088008039d669521e9afdfeb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Apr_2012_12_10_58_+1000_YEfR0R6g41BfwLOA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Apr_2012_12_10_58_+1000_YEfR0R6g41BfwLOA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "__kfifo_max_r" [drivers/media/rc/rc-core.ko] undefined!

Caused by commit 24a19bcbceda ("[media] ir-raw: Check available elements
in kfifo before adding").  kfifo_avail expands to a call to __kfifo_max_r
which is not exported to modules.

I have used the v4l-dvb tree from next-20120410 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Apr_2012_12_10_58_+1000_YEfR0R6g41BfwLOA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhOgyAAoJEECxmPOUX5FErl8QAKXE7cRdsWuL5+OXvnAb9FSk
0PkkxqHGXkv6S10X1dVFT1E5uPB32AbyaBNmLe6fqhJRuemVbRLiiVErRO/gb7AY
TuZ3PWxLEUJ49KaidWcdG7It6wkWV0W9ub2Ns43rTBu5Sr0nXQnd4bVSaE8Cvray
h2N6awDN5V0nDpyuz0IaOEduimsK45QIKaAQhS1kjSXdBwhl2PSIvxsgy+qZWnh6
Kxy4aLI2921qnHudYICC+FX3l8/P0WsWh/Fg0wqSOiFT+ujkZtg/mLL9SuJHVN+V
D/QoWPfozj+ZsTLWNrguHxB7kUiSWb5alEmopYJ31+RN6ktnjaej7Q80bxKPDXb0
OYIz/xtNn33vpRAxt9LYXG/nww42mmMdtZc51/Gpl/XqjWtTS/21uOLz4hkz6VJJ
u4u+s+qLfhI8IcHK+7CwxOpRLDFrRmO66DMSecvakodV8TdvfwpCT1k2uruM7U86
+nOjGU0lzQy6YNx6vRZmsi+4iROGsLIl+nehNf0OANlSw2y7LXfxxs2aFZuh2IpU
KXcbvkWhT/+kZABVYHwf1v7AtkFeXVnIuBpMlvK16JAkIV1yD4BRWKKVc8rqAo49
psuHRqUG7v4cDEKfkUIQaBRCAnIoxc/rb074+lm7RKqCqdWUDtpHu1eeWtk82Mb1
yiP7n1QY/9b7B/qq8qwK
=Ooqn
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Apr_2012_12_10_58_+1000_YEfR0R6g41BfwLOA--
