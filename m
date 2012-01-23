Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2AWUT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:19:59 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:45245 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2AWUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:19:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAGO9HU9bdWOb/2dsb2JhbABChQmqJoIcDwEjIzUCGA4COwMhAYgQpw2RMYEviWGBFgSVGYVWg1SJJg
X-IronPort-AV: E=Sophos;i="4.71,557,1320620400"; 
   d="scan'208";a="865381551"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/5] staging: tidspbridge: clean up drv_interface.c
Date: Mon, 23 Jan 2012 22:09:43 +0200
Message-Id: <cover.1327348286.git.vjaquez@igalia.com>
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

I would like to have some review in order to know if I could keep
moving in this direction.

Thanks

vmjl

Víctor Manuel Jáquez Leal (5):
  staging: tidspbridge: more readable code
  staging: tidspbridge: remove unused header
  staging: tidspbridge: Lindent to drv_interface.c
  staging: tidspbridge: silence the compiler
  staging: tidspbridge: remove header inclusions

 drivers/staging/tidspbridge/rmgr/drv_interface.c |  352 +++++++++++-----------
 drivers/staging/tidspbridge/rmgr/drv_interface.h |   28 --
 2 files changed, 171 insertions(+), 209 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.h

-- 
1.7.8.3

