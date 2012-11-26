Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2KZKcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:32:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43378 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2KZKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:32:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ef-50b3451df59a
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        myungjoo.ham@gmail.com
Subject: [PULL REQUEST for Rafael] PM / devfreq: rebased on pm-devfreq
Date: Mon, 26 Nov 2012 19:31:43 +0900
Message-id: <1353925903-19557-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <1562412.gSBZdyfWN8@vostro.rjw.lan>
References: <1562412.gSBZdyfWN8@vostro.rjw.lan>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t8zLV1Z180BBo19lhaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsErowZF7rZC55LVMw99Ii5gfGdcBcjJ4eEgInEkkOXmSFs
	MYkL99azdTFycQgJLGOU2Pl6BRtM0cWzbcwQiemMEpunHGSBcFqYJA7c3cYOUsUmoCuxdcNd
	FhBbRIBfYtu8o6wgNrNAiMTamefBaoQF3CT+7VgBto5FQFXiwq9usBpeAQ+JmbNfQZ2hIPHr
	yCqwOKeAgURL3zSwmUIC+hKrny1ngegVkPg2+RCQzQFULyux6QDYcRIC19kkps9exQ4xR1Li
	4IobLBMYhRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECAlH6R2MqxosDjEKcDAq8fBK
	HtsUIMSaWFZcmXuIUYKDWUmEdyITUIg3JbGyKrUoP76oNCe1+BCjD9AlE5mlRJPzgbGSVxJv
	aGxgbGhoaWhmamlqgENYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPjxnmbeXdGO7n6zTip
	c2NlacAzHU+BiKv1ibs/+2+vP/n/qfm3yrablhvXnouwPcX4lW9b7sQ5Kiusfa8pxik3Kwk/
	mFFefTJesedzuNPamhXT3zAun5Sxf72AzdlcwyWKyzflzZDMDDzbPGv9M/bCibUz5jV8qn8e
	U8P7YSfLCz6ns8IVO5zqlFiKMxINtZiLihMBYk6oBnQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQV1Z180BBh+uGVlc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzZlzoZi94LlEx
	99Aj5gbGd8JdjJwcEgImEhfPtjFD2GISF+6tZ+ti5OIQEpjOKLF5ykEWCKeFSeLA3W3sIFVs
	AroSWzfcZQGxRQT4JbbNO8oKYjMLhEisnXkerEZYwE3i344VYFNZBFQlLvzqBqvhFfCQmDn7
	FdQ2BYlfR1aBxTkFDCRa+qaBzRQS0JdY/Ww5ywRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxgoP9mfQOxlUNFocYBTgYlXh4JY9tChBiTSwrrsw9xCjBwawkwjuRCSjEm5JYWZVa
	lB9fVJqTWnyI0QfoqonMUqLJ+cBIzCuJNzQ2MTOyNDIzNjE3NsYhrCTO2+yREiAkkJ5Ykpqd
	mlqQWgQzjomDU6qBMZHnO7uQY1xFXnET38HUkrQZ1cvfzv4ckTSFyT1YZPeCrlPRjj5tD7e5
	L+N4bPr0A8/d9JTYT2reDNWTDu4Xnahvt61c9qfu1Aei8hGGR1Q/nYvOyhZU39DFLnaU1WHt
	w+aVrr5e0+v2Z/7efy3D+APDVJ3W6D1tLyZ9YpxYEZn+aY/+IlFxJZbijERDLeai4kQAcBvO
	vKMCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael,

Here goes the pull request rebased on your pm-devfreq branch.
Sorry for all the confusion and mess invoked.


Cheers,
MyungJoo

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 1a1357ea176670867f347419c3345e2becc07338:

  PM / devfreq: make devfreq_class static (2012-11-15 00:35:06 +0100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git tags/pull_req_20121126

Jonghwa Lee (1):
      PM / devfreq: Add sysfs node for representing frequency transition information.

MyungJoo Ham (2):
      PM / devfreq: remove compiler error when a governor is module
      PM / devfreq: missing rcu_read_lock() added for find_device_opp()

Nishanth Menon (9):
      PM / devfreq: documentation cleanups for devfreq header
      PM / devfreq: Add sysfs node to expose available frequencies
      PM / devfreq: export update_devfreq
      PM / devfreq: provide hooks for governors to be registered
      PM / devfreq: register governors with devfreq framework
      PM / devfreq: map devfreq drivers to governor using name
      PM / devfreq: governors: add GPL module license and allow module build
      PM / devfreq: allow sysfs governor node to switch governor
      PM / devfreq: Add sysfs node to expose available governors

Sachin Kamat (3):
      PM / devfreq: Use devm_* functions in exynos4_bus.c
      PM / devfreq: Fix incorrect argument in error message
      PM / devfreq: Fix return value in devfreq_remove_governor()

Sangho Yi (1):
      PM / devfreq: exynos4_bus.c: Fixed an alignment of the func call args.

 Documentation/ABI/testing/sysfs-class-devfreq |   29 ++-
 drivers/devfreq/Kconfig                       |    8 +-
 drivers/devfreq/devfreq.c                     |  413 ++++++++++++++++++++++++-
 drivers/devfreq/exynos4_bus.c                 |   45 +--
 drivers/devfreq/governor.h                    |    4 +
 drivers/devfreq/governor_performance.c        |   22 ++-
 drivers/devfreq/governor_powersave.c          |   22 ++-
 drivers/devfreq/governor_simpleondemand.c     |   22 ++-
 drivers/devfreq/governor_userspace.c          |   22 ++-
 include/linux/devfreq.h                       |   95 +++---
 10 files changed, 581 insertions(+), 101 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQs0NoAAoJEBOhurvWBoCK2hIQAJuTMnRiWb2BkU30ENAug1FC
oNvoFBTVA2J9vTp1Q1qtoPj+ualfg++auzt4e5U2rbAthQYpB1LYDvc/ycEpGkG0
C+V3aleb9SK0TnqWp/s2i/KLWK1fTxbMGi2nDdCwwglbn59OlY6fVTyUA+jGzk3r
AwpxSCnLhi7jhtbgSWhiQh2F5gehNXGtU6CsK0OebP2VlVK5ZFw6X3eqacfact/h
kabXBsS+jJlrA90+jFFqQ4nSyU69Kgou/+de3rzrMOFYEv+uoGNmzRofh1BRaWM+
ueyKdfF/oUJWmL8fvhMY556xrTBuGpI5btSmfYxSz+VFiDzV8HduIi8ThaVKMmGu
MR77kgFSy0NkasCQ2l6q7LYIRoFJX/MQWnQpxvpZKOi5aqEgWsdCY75juRN3wOGm
kCGecK2Rq/tTj3EzIS2brUPQJPcM1YS4QHKFYq3Oucnpbk6Ym1ojIYxTB7no7fKW
7OhVOf3IHA3C0VMg8DiN9SoOW8ILU3EvknP6BguRRVf+iFjtUWqCoaNj14BOSjUx
Ol/606xgVa6xEsDG1NeoYiEov/lmYDpHG/tnh2g5gF/YrKjbQsvT7uqSBbeFJO2u
ybI2hz37OulNvur4ORFWTCOyNqknX9t+OIFFyQjdGmaPwjnJ+IZ5kWqBwPaHxd3x
Y/8iwxoohO4ROW1pBln0
=5A1F
-----END PGP SIGNATURE-----
