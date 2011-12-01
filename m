Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1LAV4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:56:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36449 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1LAV4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:56:43 -0500
Message-ID: <1322776568.4699.52.camel@twins>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Dec 2011 22:56:08 +0100
In-Reply-To: <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 16:41 -0500, Mathieu Desnoyers wrote:
> LTTng needs this symbol to prepend the current task dynamic priority
> value to events (optional context information).

I absolutely detest exporting such stuff. It propagates the idea that
task prio actually means something. Also, modules really shouldn't care.
