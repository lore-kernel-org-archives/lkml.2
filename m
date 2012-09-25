Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab2IYBdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:33:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57125 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2IYBdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:33:39 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-39-506109f0073b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] perf hists: Move hists_init() from util/evsel.c to util/hist.c
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-2-git-send-email-feng.tang@intel.com>
	<20120924160239.GD9977@infradead.org>
Date: Tue, 25 Sep 2012 10:25:13 +0900
In-Reply-To: <20120924160239.GD9977@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 24 Sep 2012 13:02:39 -0300")
Message-ID: <87pq5ayjuu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 13:02:39 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 24, 2012 at 11:24:03PM +0800, Feng Tang escreveu:
>> Which looks more natural
>
> It is there to avoid dragging the hist code into the python binding :-\

Hmm... it's so hairy.  Can't we do better?

Thanks,
Namhyung
