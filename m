Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2K2KwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:52:23 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64700 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab2K2KwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:52:20 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-2e-50b73e62ab10
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/14] perf tool: Introduce perf_hpp__list for period related columns
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-2-git-send-email-jolsa@redhat.com>
	<87d2ywq2dg.fsf@sejong.aot.lge.com>
Date: Thu, 29 Nov 2012 19:52:18 +0900
In-Reply-To: <87d2ywq2dg.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 29 Nov 2012 16:44:59 +0900")
Message-ID: <87zk20of4t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 29 Nov 2012 16:44:59 +0900, Namhyung Kim wrote:
> Hi Jiri,
>
> On Wed, 28 Nov 2012 14:52:36 +0100, Jiri Olsa wrote:
>> Adding perf_hpp__list list to register and contain all period
>> related columns the command is interested in.
>>
>> This way we get rid of static array holding all possible
>> columns and enable commands to register their own columns.
>
> But it seems you didn't get rid of the array? :)

Ah, understood.  You wanted to add new hpp columns dynamically!
Looks good to me then.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
