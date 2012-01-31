Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2AaPwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:52:09 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:54936 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754510Ab2AaPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:52:08 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432N98dK4015Lzz1202hzzz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYO6QL-01-LGI-02
X-M-MSG: 
Date: Tue, 31 Jan 2012 16:51:54 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf tools: More fixes and updates
Message-ID: <20120131155154.GH16322@erda.amd.com>
References: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.11 17:32:38, Robert Richter wrote:
> Some more fixes and updates for perf tools.
> 
> Robert Richter (4):
>   perf tools: Fix uninitialized memory access to struct perf_sample
>   perf record: Make feature initialization generic
>   perf tools: Moving code in header.c
>   perf tools: Factor out feature op to process header sections

Arnaldo,

have you had the time to look at patches 2-4? They refactor the code
without changing functionality, but makes implementation easier and
more maintainable.

Thanks,

-Robert

> 
>  tools/perf/builtin-record.c |   28 +---
>  tools/perf/util/evsel.c     |    2 +-
>  tools/perf/util/header.c    |  344 ++++++++++++++++++++++---------------------
>  tools/perf/util/header.h    |    1 +
>  4 files changed, 190 insertions(+), 185 deletions(-)
> 
> -- 
> 1.7.7
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

