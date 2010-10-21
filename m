Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0JUCcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:32:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab0JUCca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:32:30 -0400
Message-ID: <4CBFA64D.6050800@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 10:32:45 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Nauman Rafique <nauman@google.com>, Chad Talbott <ctalbott@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 0/4] cfq-iosched: Enable hierarchical cfq group scheduling
 and add use_hierarchy interface
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

This patchset enable hierarchicals cfq group scheduling and adds new blkio cgroup
interface "use_hierarchy" to switch between hierarchical mode and flat mode.


[PATCH 1/4 v2] cfq-iosched: add cfq group hierarchical scheduling support
[PATCH 2/4] blkio-cgroup: Add a new interface use_hierarchy
[PATCH 3/4] cfq-iosched: Enable both hierarchical mode and flat mode for cfq group scheduling
[PATCH 4/4] blkio-cgroup: Documents for use_hierarchy interface
