Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2J3HYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:24:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54009 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2J3HYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:24:40 -0400
X-AuditID: 9c930179-b7c8bae000003559-26-508f80b61088
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 1/9] perf python: add ui stubs file
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
	<1351528309-87705-2-git-send-email-dsahern@gmail.com>
Date: Tue, 30 Oct 2012 16:24:38 +0900
In-Reply-To: <1351528309-87705-2-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Mon, 29 Oct 2012 10:31:41 -0600")
Message-ID: <87a9v4777t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 29 Oct 2012 10:31:41 -0600, David Ahern wrote:
> stdio based implementations of ui_xxxx based functions for the python
> library. Needed for patch 3 - consolidating open counters method.

How about adding ui/util.c to the python-ext-sources?

Thanks,
Namhyung
