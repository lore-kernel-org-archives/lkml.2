Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0HYVhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:37:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:32981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0HYVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:37:27 -0400
Date: Wed, 25 Aug 2010 21:37:07 GMT
From: tip-bot for Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, haicheng.li@linux.intel.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
In-Reply-To: <4C6E4ECD.1090607@linux.intel.com>
References: <4C6E4ECD.1090607@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Separate x86_64 vmalloc_sync_all() into separate functions
Message-ID: <tip-7b61b1ccb1a84c3391360ac94c908bfbbb35299c@git.kernel.org>
Git-Commit-ID: 7b61b1ccb1a84c3391360ac94c908bfbbb35299c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 21:37:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b61b1ccb1a84c3391360ac94c908bfbbb35299c
Gitweb:     http://git.kernel.org/tip/7b61b1ccb1a84c3391360ac94c908bfbbb35299c
Author:     Haicheng Li <haicheng.li@linux.intel.com>
AuthorDate: Wed, 19 May 2010 17:42:14 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 25 Aug 2010 13:47:14 -0700

x86, mm: Separate x86_64 vmalloc_sync_all() into separate functions

No behavior change.

Move some of vmalloc_sync_all() code into a new function
sync_global_pgds() that will be useful for memory hotplug.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
LKML-Reference: <4C6E4ECD.1090607@linux.intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
