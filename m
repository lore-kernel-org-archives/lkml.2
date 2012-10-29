Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2J2T0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:26:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:23190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab2J2T0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:26:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="210869317"
Date: Mon, 29 Oct 2012 12:25:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Subject: Re: [Patch v1 01/10] perf/x86: improve sysfs event mapping with
 event string
Message-ID: <20121029192555.GJ2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
 <1351523752-4215-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351523752-4215-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:15:43PM +0100, Stephane Eranian wrote:
> This patch extends Jiri's changes to make generic
> events mapping visible via sysfs. The patch extends
> the mechanism to non-generic events by allowing
> the mappings to be hardcoded in strings.
> 
> This mechanism will be used by the PEBS-LL patch
> later on.

I'm going to pull this patch into my Haswell patchkit to handle
the same problem. I originally had a different solution, but 
this works as well with the latest perf/core.

-Andi

