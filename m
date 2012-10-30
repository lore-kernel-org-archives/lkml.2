Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2J3H1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:27:35 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42899 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2J3H1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:27:34 -0400
X-AuditID: 9c930197-b7c0bae00000042f-6a-508f81641ffe
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 2/9] perf top: make use of perf_record_opts
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
	<1351528309-87705-3-git-send-email-dsahern@gmail.com>
Date: Tue, 30 Oct 2012 16:27:32 +0900
In-Reply-To: <1351528309-87705-3-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Mon, 29 Oct 2012 10:31:42 -0600")
Message-ID: <87625s772z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 10:31:42 -0600, David Ahern wrote:
> Changes top code to use the perf_record_opts struct. Stepping stone to
> consolidating the open counters code.

Maybe time to rename perf_record_opts to perf_open_opts or just perf_opts?

Thanks,
Namhyung
