Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2LQI05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:26:57 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58006 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2LQI04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:26:56 -0500
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
Subject: [PATCH 0/3 v2] add resync speed control for dm-raid1
Date: Mon, 17 Dec 2012 16:26:34 +0800
Message-Id: <1355732797-7233-1-git-send-email-gzhao@suse.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are used to add resync speed control for dm-raid1. The
second and third patch provide support for user-space tool dmsetup.
I have made some modifications by the comments. This is the second
version.


Guangliang Zhao (3):
  dm raid1: add resync speed control for dm-raid1
  dm raid1: add interface to set resync speed
  dm raid1: add interface to get resync speed

 drivers/md/dm-raid1.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 3 deletions(-)

-- 
1.7.10.4

