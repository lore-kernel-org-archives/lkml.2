Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3AESih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 13:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab3AESif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 13:38:35 -0500
Date: Sat, 5 Jan 2013 19:38:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v4 07/18] perf: add generic memory sampling interface
Message-ID: <20130105183816.GA995@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-8-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356018108-6081-8-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 04:41:37PM +0100, Stephane Eranian wrote:
> This patch adds PERF_SAMPLE_COST and PERF_SAMPLE_DSRC.

I guess PERF_SAMPLE_COST was replaced by PERF_SAMPLE_WEIGHT added by Andi

jirka

> The first collects a cost associated with the sampled
> event. In case of memory access, the cost would be
> the latency of the load, otherwise it defaults to
> the sampling period.
> 
> PERF_SAMPLE_DSRC collects the data source, i.e., where
> did the data associated with the sampled instruction
> come from. Information is stored in a perf_mem_dsrc
> structure. It contains opcode, mem level, tlb, snoop,
> lock information, subject to availability in hardware.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
