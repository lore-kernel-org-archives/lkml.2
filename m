Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2F1SUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:20:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:46195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2F1SUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:20:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159339957"
Date: Thu, 28 Jun 2012 11:20:30 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
Message-ID: <20120628182030.GR4152@tassilo.jf.intel.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
 <1340899974.28750.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340899974.28750.66.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not without a useful userspace part. 

http://permalink.gmane.org/gmane.linux.kernel/1319962

> Preferably not a script.

You don't need to prefer it.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
