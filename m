Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0IWLhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:37:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:53819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0IWLhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:37:23 -0400
Date: Thu, 23 Sep 2010 13:37:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] kernel/trace: Remove unnecessary casts of
 private_data
In-Reply-To: <3c301ab7b883206341b34562c6101a8b310b7aa2.1283650107.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1009231337070.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com> <3c301ab7b883206341b34562c6101a8b310b7aa2.1283650107.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  kernel/trace/ftrace.c |    4 ++--
>  kernel/trace/trace.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7cb1f45..fc9ee37 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1599,7 +1599,7 @@ ftrace_failures_open(struct inode *inode, struct file *file)
>  
>  	ret = ftrace_avail_open(inode, file);
>  	if (!ret) {
> -		m = (struct seq_file *)file->private_data;
> +		m = file->private_data;
>  		iter = (struct ftrace_iterator *)m->private;

How about m->private here?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
