Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2JVI4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:56:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43248 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2JVI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:56:33 -0400
X-AuditID: 9c930197-b7c4aae000004160-81-50850a408c0b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 04/11] perf tool: Add support for parsing PERF_SAMPLE_READ sample type
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	<1350743599-4805-5-git-send-email-jolsa@redhat.com>
Date: Mon, 22 Oct 2012 17:56:32 +0900
In-Reply-To: <1350743599-4805-5-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 20 Oct 2012 16:33:12 +0200")
Message-ID: <871ugqkhq7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2012 16:33:12 +0200, Jiri Olsa wrote:
> Adding support to parse out the PERF_SAMPLE_READ sample bits.
> The code contains both single and group format specification.
>
> This code parse out and prepare prepare PERF_SAMPLE_READ data

Doubly prepare? :)

Thanks,
Namhyung
