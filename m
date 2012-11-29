Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2K2LP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:15:58 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46613 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2LP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:15:57 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-2c-50b743ec4171
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 06/14] perf diff: Change formula methods to work with pair directly
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-7-git-send-email-jolsa@redhat.com>
Date: Thu, 29 Nov 2012 20:15:56 +0900
In-Reply-To: <1354110769-2998-7-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 28 Nov 2012 14:52:41 +0100")
Message-ID: <87r4ncoe1f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 14:52:41 +0100, Jiri Olsa wrote:
> Changing formula methods to operate over hist entry and its
> pair directly. This makes the code more obvious and readable,
> instead of all time checking for pair being != NULL.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
