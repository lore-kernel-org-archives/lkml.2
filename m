Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0ENQNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:13:04 -0400
Received: from landau.phys.spbu.ru ([195.19.235.38]:48632 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0ENQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:12:58 -0400
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: David Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>
Subject: [PATCH 0/2] drm: registering panic notifier cosmetics
Date: Fri, 14 May 2010 19:45:14 +0400
Message-Id: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.7.1.87.gcc8c60.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some minor tweaks from casual user. Please apply & thanks.

Kirill Smelkov (2):
  drm/radeon: "unregistered panic notifier" printk is redundant
  drm: Prefix info printk about registering panic notifier with 'drm'

 drivers/gpu/drm/drm_fb_helper.c    |    4 ++--
 drivers/gpu/drm/radeon/radeon_fb.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)
