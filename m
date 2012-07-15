Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2GOJWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:22:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43277 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2GOJW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:22:27 -0400
MIME-Version: 1.0
Date: Sun, 15 Jul 2012 05:22:26 -0400
Message-ID: <CAGfj0KvyV+YgXeLYqDggA06=ZxNKtF3rBOGvOPnbsrchRMH0bg@mail.gmail.com>
Subject: Unable to resolve the error
From: rakesh singh <rks.linux.88@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make -C /usr/src/linux-headers-2.6.38-8-generic/
SUBDIRS=/home/rakesh/Desktop/m modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.38-8-generic'
  CC [M]  /home/rakesh/Desktop/m/hello.o
/home/rakesh/Desktop/m/hello.c:1:70: fatal error:
usr/src/linux-headers-2.6.38-8-generic/include/linux/init.h: No such
file or directory
compilation terminated.
make[2]: *** [/home/rakesh/Desktop/m/hello.o] Error 1
make[1]: *** [_module_/home/rakesh/Desktop/m] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.38-8-generic'
make: *** [default] Error 2
