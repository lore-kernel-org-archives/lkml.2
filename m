Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2IYI67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:58:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55223 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab2IYI64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:58:56 -0400
X-AuditID: 9c930197-b7b6dae000000e70-6c-5061724c7c25
From: Namhyung Kim <namhyung@kernel.org>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com
Subject: Re: [PATCH] fix compilation error of perf/core
References: <1348561285-25587-1-git-send-email-haodong@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 17:50:30 +0900
In-Reply-To: <1348561285-25587-1-git-send-email-haodong@linux.vnet.ibm.com>
	(Dong Hao's message of "Tue, 25 Sep 2012 16:21:25 +0800")
Message-ID: <87haqmwko9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong,

On Tue, 25 Sep 2012 16:21:25 +0800, Dong Hao wrote:
> From: Dong Hao <haodong@linux.vnet.ibm.com>
>
> The newest branch of perf/core should have compilation error!
> Error log includes:
>
> builtin-test.c: In function ‘perf_evsel__test_field’:
> builtin-test.c:1216:6: error:
>  variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
> builtin-test.c: In function ‘perf_evsel__tp_sched_test’:
> builtin-test.c:1242:6: error:
>  variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
> cc1: all warnings being treated as errors
> make: *** [builtin-test.o] Error 1
> ---------------------------------------------------------------------
> Fix it by replacing return value from 0 to ret.
> Then this branch can be compiled successfully.
>
> Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>

I already sent the same patch:

  https://lkml.org/lkml/2012/9/24/689


Thanks for fixing it anyway!
Namhyung
