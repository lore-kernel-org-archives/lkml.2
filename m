Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2JURyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:54:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50454 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab2JURyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:54:19 -0400
Date: Sun, 21 Oct 2012 19:54:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH][3.7] ring-buffer: Check for uninitialized cpu buffer
 before resizing
Message-ID: <20121021175415.GB3820@gmail.com>
References: <1349986271.24256.67.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349986271.24256.67.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 8e49f418c9632790bf456634742d34d97120a784
> 
> 
> Vaibhav Nagarnaik (1):
>       ring-buffer: Check for uninitialized cpu buffer before resizing
> 
> ----
>  kernel/trace/ring_buffer.c |    4 ++++
>  1 file changed, 4 insertions(+)

Pulled, thanks Steve!

Thanks,

	Ingo
