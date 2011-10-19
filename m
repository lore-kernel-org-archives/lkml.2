Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1JSL4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1JSL4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:56:11 -0400
Message-ID: <4E9EBAD8.1050303@redhat.com>
Date: Wed, 19 Oct 2011 09:56:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.1-rc10] media fix
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:
  git://linuxtv.org/mchehab/for_linus.git v4l_for_linus


For a one line fix at the V4L2 core, causing OOPSes at device release under
certain circumstances.

Thanks!
Mauro.

Latest commit at the branch: e58fced201ad6e6cb673f07499919c3b20792d94 [media] videodev: fix a NULL pointer dereference in v4l2_device_release()
The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:

  Linux 3.1-rc10 (2011-10-17 21:06:23 -0700)

are available in the git repository at:
  git://linuxtv.org/mchehab/for_linus.git v4l_for_linus

Antonio Ospite (1):
      [media] videodev: fix a NULL pointer dereference in v4l2_device_release()

 drivers/media/video/v4l2-dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOnrrNAAoJEGO08Bl/PELnIU4P/iiuqUGQnYr5NH/keGd562Cn
INrqAJ5SO9nNjgE2Eg9fuxVGriQazEJ8s+qs1wwZrpcRkrZVq2xzy7LtC/TuBdu1
c8lStlSLN2Cmo6kfkNBuNc++6X1SWh+Rdz4l5r3N8IKNQsu6XfW1idgKql3Pwavr
Afzb18vDL8rRQC9etbxzBgtOXHj6zJw+ehdKwqx9SglF1DH72afxAv7z3UhygZYp
UVJzgjVKgAyOVQfxHKzFrpNiLQpYWJtJaTpTw+t7hOp8kNZ4rXlinmy9UYsZ8Lrr
mlcWld1F2dmDuhxj0xU+QDDOhmfXnPWbLi/VWWramBq9ksNXQzxsQriI4ZKmHg5J
nnmvkrbKB+nL/51ITfXBTxYdC5zcDfEwD1m6mge3c8r4SJaRXOuHoMtVOpKAENFj
hqBRRDnb6LjnMJhdWrgFPHGs1k/T/BoduCphwZIAU2Ii7Tz0AqCnyKL4aaWHqcwp
0ECduB1Iyr1AUVnf5S7wH3m/gukasIEIGhEH2Yqr7mG1odguM5eSdHRYTLejZw+7
I2Nk71DI099Hrnt3GAer0hEzN8Pm96xMCh5kCqD2pz6H9zoijK7K7MFD0Nf2RhZV
JKy/UNwDTGAx3989G0nUu5KWmfYvvqgzZUYNgN1IZhde/YEHldIUOxY6yf3gZy9J
twUAlsCBnY/6povAvdMH
=RCnh
-----END PGP SIGNATURE-----
