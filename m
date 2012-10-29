Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab2J2QzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:55:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:15617 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759913Ab2J2QzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:55:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="161970092"
Date: Mon, 29 Oct 2012 09:55:15 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Subject: Re: [Patch v1 07/10] perf tools: add mem access sampling core support
Message-ID: <20121029165515.GI2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
 <1351523752-4215-8-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351523752-4215-8-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:15:49PM +0100, Stephane Eranian wrote:
> This patch adds the sorting and histogram support
> functions to enable profiling of memory accesses.

I hope my weight patches get in soon.

Could you merge your cost with weight then?

Otherwise having both cost and weight would be a bit redundant.

-Andi
