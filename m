Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1GWHre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:47:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56080 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1GWHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:47:27 -0400
MIME-Version: 1.0
Date: Sat, 23 Jul 2011 09:47:26 +0200
Message-ID: <CAC9WiBjVqgiwzuXbmbmZ49WDRHMUGtnbp999c_zZj2BkfadHvg@mail.gmail.com>
Subject: Failing to run make modules_install
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David.Woodhouse@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[ resending because of me doing weird stuff with my fingers, so this
post may appear twice, sorry if that happens ]

I'm trying to install module of 2.6.39.1 and getting this error:

make -s INSTALL_MOD_PATH=/tmp/modules-for-2.6.39.1 -j4 modules_install
make[1]: *** No rule to make target
`/tmp/modules-for-2.6.39.1/lib/firmware/./', needed by
`/home/fmoreau/linux/lib/firmware/atmsar11.fw'.  Stop.
make[1]: *** Waiting for unfinished jobs....
make: *** [_modinst_post] Error 2

After googling a bit, some suggest that the issue is coming from a
recent version of make(1), mine is 3.82.

Does anybody encounter this already ?

Thanks
-- 
Francis
