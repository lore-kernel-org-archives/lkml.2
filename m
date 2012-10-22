Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2JVEDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:03:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29148 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2JVEDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:03:54 -0400
X-AuditID: cbfee61b-b7f616d00000319b-24-5084c5a81d9a
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, myungjoo.ham@gmail.com
Subject: [GIT PULL] extcon fixes for Linux 3.7
Date: Mon, 22 Oct 2012 13:04:40 +0900
Message-id: <1350878680-12164-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zbd0VR1sCDM4fErW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjSs6mAuOiFY83LuFqYGxQaiLkZNDQsBE4v6dR6wQtpjEhXvr
	2boYuTiEBJYxSvw8s5EVpmjl7/ssEInpjBL/f59mhXCWMklsPPiMBaSKTUBXYuuGu2C2iICc
	xJPbf5hBbGaBHImutz1gtrCAnsTpbdvAalgEVCUWfV/MDmLzCnhIzJzyCWqbgsSCe2/ZIGoE
	JL5NPgRUzwEUl5XYdIAZomQLm8SUn0wQtqTEwRU3WCYwCi5gZFjFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERJS0jsYVzVYHGIU4GBU4uG1mNESIMSaWFZcmXuIUYKDWUmE91Q8UIg3JbGy
	KrUoP76oNCe1+BCjD9AhE5mlRJPzgeGeVxJvaGxgbGhoaWhmamlqgENYSZy32SMlQEggPbEk
	NTs1tSC1CGYcEwenVAOjRbPo65iO79cNVvE1Gy+eurF8nebdxecyp/zwe31Pev/p5pSwlhpx
	9nOHfactOXg4W2PhSvkzPVJhoTXT5Cxa57y4UWsXGsV7lHGDt1jIJNacc06pW755isw+mC6z
	8GZQzaE50ntP6pR09E89aONy5GAq29TJhy5bT7z/9sucJxpWJ4/x7opcq8RSnJFoqMVcVJwI
	APD5wvxWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd0VR1sCDF41Clpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMYVHcwFR0QrHu7dwtTA
	2CDUxcjJISFgIrHy930WCFtM4sK99WxdjFwcQgLTGSX+/z7NCuEsZZLYePAZWBWbgK7E1g13
	wWwRATmJJ7f/MIPYzAI5El1ve8BsYQE9idPbtoHVsAioSiz6vpgdxOYV8JCYOeUTK8Q2BYkF
	996yTWDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOGSfSe9gXNVgcYhRgINRiYfX
	YkZLgBBrYllxZe4hRgkOZiUR3lPxQCHelMTKqtSi/Pii0pzU4kOMPkDbJzJLiSbnA+MpryTe
	0NjEzMjSyMzYxNzYGIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGuRdUvyyoep7hGuoY
	sFZmrmzE0xX5+qysTdrJvueOaXTPc9CyPDG1s/Xy6rVaezqW/bjelXAl7voe6b6eU8zl625s
	zw7U8NF8WThrvqXP46kZTX/2StsWPcjrmN0qVL8310Tsck+W1KQtPx7nXA+I3LZYbnvs1Iaa
	x3JJt+/1iy8Tq01jCFmuxFKckWioxVxUnAgAG+JH7oYCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello Greg,


The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-next

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

anish kumar (5):
      extcon: standard cable names definition and declaration changed
      extcon: optimising the check_mutually_exclusive function
      extcon: checkpatch warning removal
      extcon: driver model release call not needed
      extcon: trivial: kfree missed from remove path

 drivers/extcon/extcon-adc-jack.c |   10 ++-
 drivers/extcon/extcon-class.c    |  143 +++++++++++++++++++++----------------
 drivers/extcon/extcon-gpio.c     |    1 -
 drivers/extcon/extcon-max77693.c |   46 +++++++++---
 drivers/extcon/extcon-max8997.c  |    6 +-
 include/linux/extcon.h           |    2 +-
 include/linux/mfd/max77693.h     |   13 ++++
 7 files changed, 138 insertions(+), 83 deletions(-)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQhMSxAAoJEBOhurvWBoCKpYUP/2XtOkfRONMoSzdTjmE4sR+m
6Ze1rB4T6gi8NYudpcwhVJ9x/vGubJgFUEKw9seE7+j6Ryi/UxgnDdQMRpClnAg0
cbDvb6cuzNdO+VWyOh4hlVtIaQKiet2/ZCqwlliX3Gg3zB5AizYXFHwNy/iAJvfO
6xqpeFay57Z3LISxQSXJPJGv4AT6la4hZzDwUMpTJubc/WHqCkZpwDFPFsRZi7Pr
+0BqLtnNZdqdzD/c5GwDo1Wp3TU1EuL+DPYjAYE5szLAhTVZ8/a6et2CUzskjXGF
8EGgfavxAYGu7O1YMlukTHQxfbJ9Gdk7d0nWCIppcQ62JB23C+1H7OX/7Mx75vzX
ZlmsJQvwh8m18LmZg6X5nwTkGX+XNPjZeCh6uOnBOV+TvHET3Kj8ZY03ELSPxCGD
bGFDwHucEUwd1L/eIltoHRyscg0HkRiUVTmN/HdetLihOGMgK8Kglbz3kQGuxmmu
2lCMD6Hdr6xkG4VkhHCkEPUY8fLh4Bvi8AQTP2qDmuYA5yNZFOavV2g59oLIQ3f1
9LTu014T7QuqTyY2zQYZKIVQG1sGcj2q9y0/AXbWjuZKqoWlBqRp/D9yvUcdnPxo
kqwi4nv32Vnn1rzLFFxf65uDQ2L4sNGxWPo7vCGlhfYyNQoYOSd63UJfPstbFW28
JHVWg71WQPxR1mGCUGYk
=9KTH
-----END PGP SIGNATURE-----
