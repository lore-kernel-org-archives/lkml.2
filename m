Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2GRSww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:52:52 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:32979 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab2GRSwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:52:49 -0400
Message-Id: <20120718185227.717474436@muttley.lan.cathedral>
User-Agent: quilt/0.60-1
Date: Wed, 18 Jul 2012 14:52:27 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, aris@redhat.com, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: [PATCH v4 0/3] cgroup: add xattr support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series are a refreshed version of a patchset submitted by Li Zefan back
in march:
	https://lkml.org/lkml/2012/3/1/13

With Li's permission, I refreshed the patches to apply over the latest upstream
and added the modifications suggested by others in the thread:
- using a mount option instead of config option to enable the xattr support
- reinitialize the list in kmem_xattrs_free()
- renamed functions to simple_xattr_*()

v4:
- implemented requested changes by Tejun Heo in patch #2

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

