Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2KZGlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:41:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2KZGlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:41:22 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-87-50b30f10fa05
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        myungjoo.ham@gmail.com, sachin.kamat@linaro.org
Subject: [PULL REQUEST for Rafael] PM / devfreq: pull request-3 bugfixes
Date: Mon, 26 Nov 2012 15:41:22 +0900
Message-id: <1353912082-8550-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <3622510.QVzP2QoHuh@vostro.rjw.lan>
References: <3622510.QVzP2QoHuh@vostro.rjw.lan>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t8zXV0B/s0BBi/vqVlc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLObJ/DUvBfoOLCw61MDYz3+LoYOTkkBEwkHqw7wAJh
	i0lcuLeerYuRi0NIYBmjxM3r/UwwRWtevoFKTGeUmPJrJiOE08IksW3tLFaQKjYBXYmtG+6C
	jRIR4JfYNu8oWJxZIFdixdxlYLawgIdEx5VGZhCbRUBVoqvnLJjNK+Au8fPyRFaIbQoSv46s
	ArM5BQwkttzYADZTSEBf4tb8OewQvQIS3yYfAopzANXLSmw6wAxyj4TAdTaJvr5TbBBzJCUO
	rrjBMoFReAEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MkHCU2sG4ssHiEKMAB6MSD2/h
	iU0BQqyJZcWVuYcYJTiYlUR4JzIBhXhTEiurUovy44tKc1KLDzH6AF0ykVlKNDkfGCt5JfGG
	xgbGhoaWhmamlqYGOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTCK7T1ooLHpU0a4Rp4B
	0/5yi1xr29WnXfw7RSa6ywXu8HJ7xLG1MoZhFpPzTmmuZVrMQldCrmdx7awWEOCwXq+zPX+W
	ps2Udb8cgpwjbv6e3fAnsoenamlCiaGJO+8z0+08+6W4nd/VrZ1Y/oF/czH7WZHke6H856ez
	Fb2xetJzMfl75NmUJUosxRmJhlrMRcWJAMppwi50AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQV0B/s0BBqcPK1hc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzzmyfw1LwX6Di
	wsOtTA2M9/i6GDk5JARMJNa8fMMGYYtJXLi3Hsjm4hASmM4oMeXXTEYIp4VJYtvaWawgVWwC
	uhJbN9xlAbFFBPglts07ChZnFsiVWDF3GZgtLOAh0XGlkRnEZhFQlejqOQtm8wq4S/y8PJEV
	YpuCxK8jq8BsTgEDiS03NoDNFBLQl7g1fw77BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGCg/2Z1A7GlQ0WhxgFOBiVeHgLT2wKEGJNLCuuzD3EKMHBrCTCO5EJKMSbklhZlVqU
	H19UmpNafIjRB+iqicxSosn5wEjMK4k3NDYxM7I0MjM2MTc2xiGsJM7b7JESICSQnliSmp2a
	WpBaBDOOiYNTqoGRl4f1Ol+F7AHnvrgTzZn7HtXtNp92b3OY14tdsUvOnoxTuNFtmf9yv2Rj
	wozHUVs+su3VeOgR2Xqlc+Me/t7vimlmssaaJaGzjRssN59d/yvBY1rxTguVmAcXpqYvDeea
	+Cjw29Wq3QvfaimaMHsuVf7+su/f16Cr8vV3fFa+DVp9/2liElOtEktxRqKhFnNRcSIAwQ07
	paMCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rafael,

sorry for the inconviences; I forgot that I've updated the tag name
according to the date modified.

Please use "pull_req_20121122" tag instead of "pull_req_20121121" though
I've pushed pull_req_20121121 tag again, which points to the same
commit with pull_req_20121122 tag.


"remove compiler error" patch in this set should resolve the "build failure"
message sent by Stephen as well.

Cheers,
MyungJoo

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit f928d1ce87ad5bd2152cb522de75de03be29e18b:

  Merge branch 'pm-cpufreq-next' into linux-next (2012-11-22 00:23:28 +0100)
, which is HEAD of Rafael's linux-pm.git linux-next branch on 2012-11-22.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git tags/pull_req_20121122

MyungJoo Ham (2):
      PM / devfreq: remove compiler error when a governor is module
      PM / devfreq: missing rcu_read_lock() added for find_device_opp()

Sachin Kamat (2):
      PM / devfreq: Fix incorrect argument in error message
      PM / devfreq: Fix return value in devfreq_remove_governor()

 drivers/devfreq/devfreq.c |   30 ++++++++++++++++++++++--------
 include/linux/devfreq.h   |    2 +-
 2 files changed, 23 insertions(+), 9 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQsw0gAAoJEBOhurvWBoCKFzsP/1uIw/V8sF7/Bi6yYEQVxIxF
nrgH0BtjSMKyyEG+RJU5fz1xxkfzVIhLHeMzzTDHYG/sY7xwb+eeHWE+PFP6elvm
NSCOqFf/olNM1dDrUsPpGPtn2Fmfl1wyAOXhdH1lHwQYyDyCgWgQtsqIck1UaLo2
6vn9GSl/e/DfpVtg1Wdc63ggtAFk8srZKlU3RQk/Nh/GFMTmdxtG6hibjuM88FjT
hfFETgaZYPfX+rz36XMa/7pMQQHcrl56K8r3Pu1/RhkM8lVCwlB4tV0Y2sBGfHuL
2f0mbX+owjR4YuHS1QMI31Io9FB/F5KzVUdEKE73g2yalCa8ygJfMvJgQqbMYKpA
IfxyoEvIzbH/T6+cMCQ0WaQ9Buf4KSjmmzL8MSiZB9Ny4Jw5ETg8bZjEU7cR7RWz
i1grMqyfsjySu/N+slyY7SlvKK+58DytR2WvFvz4ba58dsqEjOoL2ovFz+W3KdlE
6V8DGpi2bODbejm6pXx5K6x+VqrByMYCrRpSvmSpYG9PUWpUfjFQMMPgH/uTEXR6
dJ0H8Hv5+xtUa9sHu9A6nVVSlFgukEVN5BjIEySuX+gj5mIywwN2ZXyIp0TeAis6
SWUBFflIbjW9JuIP1hwdcrdRsgJ/RyoQZ2XqPVZEQKJgV6C+k38ShOO9Q3YAfJHq
sO3Gz4WUsME2nkswuwgb
=SPXQ
-----END PGP SIGNATURE-----
