Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2A3XMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:12:44 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:49114 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2A3XMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAB4jJ09bdWOb/2dsb2JhbABDhQuqUYIcDwEjIzUCGA4COwMhAYgRpwaRXYEviVABBQICAggBAQQNBAYBCwkIFBeDM14VgkKBFgSVGoVWg1aJJg
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795212"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 0/8] staging: tidspbridge: clean up drv_interface.c
Date: Tue, 31 Jan 2012 00:12:16 +0100
Message-Id: <cover.1327964066.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to learn how to contribute to the kernel and dsp/bridge is
a module that I have used for a while.

These patches are the result of this first effort. It is a clean up of
the file drv_interface.c which is the entry point of the kernel
module.

Thanks

v2:

* Removed changes in lines with pr_* and dbg_*, so Joe Perches could
  apply his patches for the format string without big rebases.
* Reviewed the modifications done by Lindent
* Added a clean up to the function bridge_mmap()
* Added a patch removing a unused global variable (driver_name)
* Added a patch that removes an always-true assert

vmjl

Víctor Manuel Jáquez Leal (8):
  staging: tidspbridge: more readable code
  staging: tidspbridge: remove unused header
  staging: tidspbridge: Lindent to drv_interface.c
  staging: tidspbridge: silence the compiler
  staging: tidspbridge: remove header inclusions
  staging: tidspbridge: remove trivial assert
  staging: tidspbridge: clean up bridge_mmap()
  staging: tidspbridge: use the driver name string

 drivers/staging/tidspbridge/rmgr/drv_interface.c |  348 ++++++++++-----------
 drivers/staging/tidspbridge/rmgr/drv_interface.h |   28 --
 2 files changed, 166 insertions(+), 210 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.h

-- 
1.7.8.3

