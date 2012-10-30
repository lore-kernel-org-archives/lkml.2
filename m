Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2J3Inx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:43:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62077 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2J3Inu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:43:50 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-e0-508f9342d7ab
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        ming.m.lin@intel.com
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load Latency
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-5-git-send-email-eranian@google.com>
Date: Tue, 30 Oct 2012 17:43:46 +0900
In-Reply-To: <1351523752-4215-5-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Mon, 29 Oct 2012 16:15:46 +0100")
Message-ID: <87wqy85ozh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Mon, 29 Oct 2012 16:15:46 +0100, Stephane Eranian wrote:
> +	/*
> +	 * use the mapping table for bit 0-15
> +	 */
> +	val = pebs_data_source[dse.ld_dse];

I guess you meant bit 0-3, right?

Thanks,
Namhyung
