Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab0HWBR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:17:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65217 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0HWBRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:17:25 -0400
Message-ID: <4C71CD4B.10606@cn.fujitsu.com>
Date: Mon, 23 Aug 2010 09:22:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] btrfs: some bug fixes for free space cache
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those bugs are not critical, which means they won't crash the
filesystem, so they're hardly noticeable and no one noticed
them.

---
 fs/btrfs/free-space-cache.c |  161 ++++++++++++++++++++++++++-----------------
 1 files changed, 99 insertions(+), 62 deletions(-)
