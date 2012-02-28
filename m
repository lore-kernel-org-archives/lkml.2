Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab2B1I6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:58:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab2B1I6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:58:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.57.163 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Tue, 28 Feb 2012 17:58:02 +0900
X-Google-Sender-Auth: ziF4Ygdqb53qe1GoHFefoodiPOk
Message-ID: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
Subject: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce External
 Connector Class (extcon))
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,


Presuming that the requests and comments upto v5 patchsets were
addressed in the last patchset (v6), here goes a pull request of
Extcon.



The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung extcon-for-next

Donggeun Kim (1):
      Extcon: support notification based on the state changes.

MyungJoo Ham (4):
      Extcon (external connector): import Android's switch class and modify.
      Extcon: support generic GPIO extcon driver
      Extcon: support multiple states at a device.
      Extcon: support mutually exclusive relation between cables.

 Documentation/ABI/testing/sysfs-class-extcon |   97 +++
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/extcon/Kconfig                       |   35 ++
 drivers/extcon/Makefile                      |    6 +
 drivers/extcon/extcon_class.c                |  812 ++++++++++++++++++++++++++
 drivers/extcon/extcon_gpio.c                 |  175 ++++++
 include/linux/extcon.h                       |  322 ++++++++++
 include/linux/extcon/extcon_gpio.h           |   52 ++
 9 files changed, 1502 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-extcon
 create mode 100644 drivers/extcon/Kconfig
 create mode 100644 drivers/extcon/Makefile
 create mode 100644 drivers/extcon/extcon_class.c
 create mode 100644 drivers/extcon/extcon_gpio.c
 create mode 100644 include/linux/extcon.h
 create mode 100644 include/linux/extcon/extcon_gpio.h



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
