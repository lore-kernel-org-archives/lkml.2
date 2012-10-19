Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2JSJNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:13:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:1439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab2JSJNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,612,1344236400"; 
   d="scan'208";a="208033815"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com
Subject: Re: perf PMU support for Haswell v3
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
Date: Fri, 19 Oct 2012 02:13:40 -0700
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 18 Oct 2012 16:19:08 -0700")
Message-ID: <m2bofysu2j.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> [Updated version for the latest master tree and various fixes.
> See end for details. This should be ready for merging now I hope.]

This is also now available at
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu3

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
