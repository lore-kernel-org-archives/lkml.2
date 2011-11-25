Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1KYNRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:17:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1KYNRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:17:13 -0500
Date: Fri, 25 Nov 2011 14:12:41 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        wli@holomorphy.com, david.woodhouse@intel.com, allen.m.kay@intel.com,
        mtosatti@redhat.com, chrisw@redhat.com, andi@firstfloor.org,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] thp: Add compound tail page _mapcount when mapped
Message-ID: <20111125131241.GZ8397@redhat.com>
References: <1322200030-26350-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322200030-26350-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both are needed to take care of CONFIG_DEBUG_VM false positives. Worst
case a false positive hits, but if it doesn't there was no risk because
the tail page refcounting isn't actively used by that code and the
refcounting on the head page was done right already.

Thanks,
Andrea
