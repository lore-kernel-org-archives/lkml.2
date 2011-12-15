Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab1LOXFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:05:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48414 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576Ab1LOXFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:05:19 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/3] musb fixes and cleanups
Date: Fri, 16 Dec 2011 01:05:07 +0200
Message-Id: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a few cleanups and a possible fix. Nothing major.

Felipe Contreras (3):
  usb: musb: fix pm_runtime mismatches
  usb: musb: trivial cleanup
  usb: musb: remove a bit of indentation

 drivers/usb/musb/musb_gadget.c |    1 +
 drivers/usb/musb/omap2430.c    |   36 +++++++++++++++---------------------
 2 files changed, 16 insertions(+), 21 deletions(-)

-- 
1.7.8.rc1.14.g248db

