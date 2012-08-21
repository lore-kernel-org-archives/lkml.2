Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2HUKJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:09:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2HUKJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:09:06 -0400
Message-ID: <1345543728.23018.84.camel@twins>
Subject: Re: [RFC PATCH -v2 3/4] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 21 Aug 2012 12:08:48 +0200
In-Reply-To: <1345139123-15212-4-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <1345139123-15212-4-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 19:45 +0200, Borislav Petkov wrote:
> + err_counter:
> +       perf_event_release_kernel(event);
> +
> + err_inode:
> +       trace_remove_file(desc->dentry);
> +
> + err_trace_file:
> +       put_unused_fd(event_fd);
> +       return event;
> +} 

Note that perf code has unindented labels.
