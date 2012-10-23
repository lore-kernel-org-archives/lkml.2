Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2JWIRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:17:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45980 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2JWIRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:17:33 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-e5-5086529c9378
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: gregkh@linuxfoundation.org
Cc: axel.lin@ingics.com, anish198519851985@gmail.com, jenny.tc@intel.com,
        cw00.choi@samsung.com, sachin.kamat@linaro.org, peterhuewe@gmx.de,
        develkernel412222@gmail.com, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL v2] extcon fixes for Linux 3.7
Date: Tue, 23 Oct 2012 17:18:20 +0900
Message-id: <1350980300-15397-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <20121022195606.GA13640@kroah.com>
References: <20121022195606.GA13640@kroah.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zXd05QW0BBn9uslpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MqzvfMhV8EatY+/sbawPjJOEuRk4OCQETiW2rP7BD2GISF+6t
	Z+ti5OIQEljGKPGi/w8bTFHHq9csEInpjBKzem8zQzhLmST2Xb8D1s4moCuxdcNdFhBbREBO
	4sntP2BFzAJPGCWWbDvFCJIQFjCU+HbpNlgRi4CqxKL/m5hAbF4BD4lr968yQaxTkFhw7y3Y
	ak4BfYnfu/6zgthCAnoS3xc8heoVkPg2+RCQzQFULyux6QDYLgmB62wSx0+3M0PMkZQ4uOIG
	ywRG4QWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxQsJQagfjygaLQ4wCHIxKPLwWR1oD
	hFgTy4orcw8xSnAwK4nwmtq3BQjxpiRWVqUW5ccXleakFh9i9AG6ZCKzlGhyPjBG8kriDY0N
	jA0NLQ3NTC1NDXAIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg9C4o1euM6djnsFDrQ+5X
	DsNLG67Hvma12iW+edq8Dx9fTpmjzX5ool6I4+yGJXL7qqxSttbKbxCLlDuRJSEbZHqVe8n8
	LtPHStYPrlpYH7K/Okty+/3fCofP3uu46d9V0XHr6rKu2peq+pbmlf7veZrOVN+VW547vfrn
	U7Vic42bFnLsISwiSizFGYmGWsxFxYkAheIwsXACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoO6coLYAg3/RFpd3zWFzYPT4vEku
	gDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj6s63TAVfxCrW/v7G2sA4
	SbiLkZNDQsBEouPVaxYIW0ziwr31bF2MXBxCAtMZJWb13maGcJYySey7focdpIpNQFdi64a7
	YB0iAnIST27/AStiFnjCKLFk2ylGkISwgKHEt0u3wYpYBFQlFv3fxARi8wp4SFy7f5UJYp2C
	xIJ7b9lAbE4BfYnfu/6zgthCAnoS3xc8ZZnAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5y
	fu4mRnCIP5PawbiyweIQowAHoxIPr8WR1gAh1sSy4srcQ4wSHMxKIrym9m0BQrwpiZVVqUX5
	8UWlOanFhxh9gK6ayCwlmpwPjL+8knhDYxMzI0sjM2MTc2NjHMJK4rzNHikBQgLpiSWp2amp
	BalFMOOYODilGhgrVKNPvjh1rFzhx6etHRELzMquOU2KVV+uWrxsl2+h3te3YuxFTGn7Y897
	XVOe+Sh7TtcC7VM3ZHzkl2UucPySvqnld+Q2UY0fPP5nHnOobL+jW2hyTO9CsAE/l+61+x9U
	HzFGB5+YH376T7Mox2WLA283H7aa86jAtK5EdL3t5xLbRX6MkbFKLMUZiYZazEXFiQBJTHd0
	ngIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hello Greg,

Please pull:
The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git bugfixes
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git tags/fixes-for-3.7

Axel Lin (4):
      extcon: adc-jack: Fix checking return value of request_any_context_irq
      extcon: adc-jack: Add missing MODULE_LICENSE
      extcon: Fix kerneldoc for extcon_set_cable_state and extcon_set_cable_state_
      extcon: max77693: Use max77693_update_reg for rmw operations

Chanwoo Choi (1):
      extcon: MAX77693: Add platform data for MUIC device to initialize registers

Devendra Naga (1):
      extcon-max8997: remove usage of ret in max8997_muic_handle_charger_type_detach

Jenny TC (1):
      extcon : register for cable interest by cable name

Peter Huewe (2):
      extcon: Unregister compat class at module unload to fix oops
      extcon: unregister compat link on cleanup

Sachin Kamat (2):
      extcon: Remove duplicate inclusion of extcon.h header file
      extcon: Fix return value in extcon_register_interest()

anish kumar (4):
      extcon: standard cable names definition and declaration changed
      extcon: optimising the check_mutually_exclusive function
      extcon: driver model release call not needed
      extcon: trivial: kfree missed from remove path

 drivers/extcon/extcon-adc-jack.c |   10 ++-
 drivers/extcon/extcon-class.c    |  142 +++++++++++++++++++++----------------
 drivers/extcon/extcon-gpio.c     |    1 -
 drivers/extcon/extcon-max77693.c |   46 +++++++++---
 drivers/extcon/extcon-max8997.c  |    6 +-
 include/linux/extcon.h           |    2 +-
 include/linux/mfd/max77693.h     |   13 ++++
 7 files changed, 138 insertions(+), 82 deletions(-)

- --
Updated since v1:
- - Moved checkpatch warning corection to for-next tree.


Thanks.


Cheers,
MyungJoo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQhlGFAAoJEBOhurvWBoCKpfEP/1OsMqbNKIe6ZZKLji6Cl8s5
ceZlvRdmEsWnNtxNfQ2F0ugTcpoC4tVTB6TVj5yoIhM7uymoaeNaC3q4XNuYToeJ
2t/gBtiu42moVgw+mgflL2R6RikIWuVzyaJr7xrWXTF+EI9ExIAZFU5H/tm5hVUU
dzb/UpVLpfkP7iRII1+Z6s+BMEeQgJTTymOcfNaIaM5MDK82o1A1SqI+jFRVC6vi
IHhD0ZARiQNdVRsDRQaoaG/1EArVYWUEyH1/IxLBZUif8c6enbNssgSbwCIrA5GZ
NpwgtVLueNBGfYf5nXUG40rdOUR4rQijXgR4k/o+CDSi8pzCrnrwfa6u5e/sKNMF
LH5XeF5P0GvXlyS4h8qb054EoJidDzhfyb2PJiWWAdq4HufEj1sjb00tt0Qaw9zS
eAi0IXPRsspyTuiK+z6p+7WAhvS2tA0uJS2mEkuuoRQYnBfNSTzPsSUyjBQR66J7
W6SZALDqfK1cHKyGDGfseBXCJZp9UVA3hW5SDlqUZlYh9SqMq1s45PlverJ0fxu3
LpJ38v4LeQJ8EfuoazBxEpD/+i9oLcfXUIiK9weMiDTJDMmSzPjZfdhqGBNZVpgL
cnaqimr0VomwuK4s8CXiMov/AZw7/gWJ3OT4ya8UdeB3Cxy6mLAQ9ob8HMeDQCCK
ZlWlytYbiA+z89xqgP05
=BfUH
-----END PGP SIGNATURE-----
