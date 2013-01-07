Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3AGKCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:02:35 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49611 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3AGKCe (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 7 Jan 2013 05:02:34 -0500
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
Subject: [PATCH 0/3 v3] add resync speed control for dm-raid1
Date: Mon,  7 Jan 2013 18:02:10 +0800
Message-Id: <1357552933-26126-1-git-send-email-gzhao@suse.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are used to add resync speed control for dm-raid1. The
second and third patch provide support for user-space tool dmsetup.
I have made some modifications by the comments. This is the third
version.

Guangliang Zhao (3):
  dm raid1: add resync speed control for dm-raid1
  dm raid1: add interface to set resync speed
  dm raid1: add interface to get resync speed

 drivers/md/dm-raid1.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

-- 
1.7.10.4

