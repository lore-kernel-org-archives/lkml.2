Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1LSXhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:37:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:49854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1LSXg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:36:59 -0500
Message-ID: <1324337807.24621.24.camel@twins>
Subject: Re: [PATCH 1/2] tracing, sched: move the sched_switch tracepoint
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Dec 2011 00:36:47 +0100
In-Reply-To: <1324337005-31718-2-git-send-email-asharma@fb.com>
References: <1324337005-31718-1-git-send-email-asharma@fb.com>
	 <1324337005-31718-2-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 15:23 -0800, Arun Sharma wrote:
> +++ b/kernel/sched.c

Also, you're patching a non-existent file :-)
