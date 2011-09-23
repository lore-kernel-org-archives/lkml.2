Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1IWAXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:23:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43044 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1IWAXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:23:00 -0400
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, adilger@whamcloud.com,
        johann@whamcloud.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikitas_angelinas@xyratex.com, andrew_perepechko@xyratex.com
Subject: [PATCH 0/2] ext4: Some MMP fixes
Date: Fri, 23 Sep 2011 01:23:07 +0100
Message-Id: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some small fixes for the multiple mount protection feature in ext4.

Nikitas Angelinas (2):
      ext4: MMP: kmmpd should use nodename from init_uts_ns.name, not sysname
      ext4: MMP: fix error message rate-limiting logic in kmmpd

 fs/ext4/mmp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

