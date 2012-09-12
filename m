Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2ILGcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:32:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64893 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2ILGcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:32:24 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-f2-50502c74c05f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 4/5] perf ui/browser: Use perf_hpp__format functions
References: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
	<1346640790-17197-5-git-send-email-namhyung@kernel.org>
	<20120908003218.GC20401@ghostprotocols.net>
	<87ehmca9u0.fsf@kernel.org>
Date: Wed, 12 Sep 2012 15:25:29 +0900
In-Reply-To: <87ehmca9u0.fsf@kernel.org> (Namhyung Kim's message of "Sat, 08
	Sep 2012 23:05:43 +0900")
Message-ID: <87fw6nahba.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2012 23:05:43 +0900, Namhyung Kim wrote:
> On Fri, 7 Sep 2012 17:32:18 -0700, Arnaldo Carvalho de Melo wrote:
>> I folded the patch below so that we have the lines starting at column 1
>> like before, i.e. we were using " %5.2f" for the overhead and now you
>> changed it to "%5.2f".
>
> Looks good to me.

It wasn't good actually :-/  Simply because it cannot refresh the
character at column 0 anymore.  I will send a fix soon.

Thanks,
Namhyung
