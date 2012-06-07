Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2FGCib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:38:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2FGCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:38:30 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=oioPlalLgeHcZa3h1WIA:9 a=PUjeQqilurYA:10 a=o18UIOG-KAijlCAz:21 a=dk6YzpboRIirwCYy:21 a=T_60X7iJLWoLFXNrjrMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339036704.13348.562.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.33-rt53
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 06 Jun 2012 22:38:24 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VwtXzZS9VnqIH97wE7Qa"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VwtXzZS9VnqIH97wE7Qa
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.33-rt53 stable release.


This release is just an update to the new stable 3.0.33 version
and no RT specific changes have been made.

(one exception: commit 93505585 workqueue: skip nr_running sanity check in =
worker_enter_idle() if trustee is active
  has been reverted. Thanks to Ibrahim Umar for pointing out the
  build failure. The commit was to remove a triggering of a false
  WARN_ON, but it required variables that did not exist in the -rt
  workqueue version. Hopefully we do not see this false positive.)


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 1bc0637a6e466f764ad41b780f552fc8bc9d6f49


Or to build 3.0.33-rt53 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.33.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.33-rt53.=
patch.xz



Enjoy,

-- Steve



--=-VwtXzZS9VnqIH97wE7Qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0BQgAAoJEIy3vGnGbaoASccP/1ZG+9mAXPs3yqzuH2B2wZtL
nKB3PZQvS17M7lv5aay23ZBocG9jreaZZwaPC892+xmkoCFH5wNWuK6kCXXt7YSB
xFtNN5zRzWLcvwdM64UAmAF0qOoeOrSKBr/RjVLYwsMAhupGHhZ4Fd9Ss82UU3ir
qfV1v7YufwebIgzdWhwKBU40jsBOLcQPrDBWP8l4mWpKvukpw+73XxdAOXgrbY5Z
GS9iQA6c7fE5Z8X3xkPMKDhILoPhBptU+0LwDvWLcLG3pYopPQxIE90aNSQjxVIl
XkPRWMo2AkL20M32DB8AE4ulsPeVPpJ2+v4utxbRw92lUQTkARhLVvlgumIJ8EUY
Rl31DbI7MAPTTdXT1RVh8GBoxU7oxsBLlsbJvPkbcQmm3Ngxi4/kL8/8Roq9efwi
1B/PROERCvEca+1ipRwsOVBDN9mma0gaX/7ljs6WFMlZqkvRO7BvOuQ345vdALhY
P/qP5Mfk81URhE6HcTdylk492JZknCq56ROguU2vj3ybwcMNQyjKugKfzMRtESKP
mQCDtiyTPkpaIGKbJUv8Kg6vrDSAUGIEqndQ+j4BAPMgn7CEBPnuaF0ePCsIdsTj
G67/kqqLQtunB0tf4IB6wgWg5U4g87ppXJpH5MsW8b008ImrZTE4qZF8XS5ZDM09
QEK72f3EaP98HvqEbZBq
=riN/
-----END PGP SIGNATURE-----

--=-VwtXzZS9VnqIH97wE7Qa--

