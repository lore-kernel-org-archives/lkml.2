Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2ASQbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:31:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55705 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2ASQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:31:33 -0500
Date: Thu, 19 Jan 2012 17:31:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 1/7] ftrace: Change filter/notrace set functions to
 return exit code
Message-ID: <20120119163124.GA18056@somewhere>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326912275-26405-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 07:44:29PM +0100, Jiri Olsa wrote:
> Currently the ftrace_set_filter and ftrace_set_notrace functions
> do not return any return code. So there's no way for ftrace_ops
> user to tell wether the filter was correctly applied.
> 
> The set_ftrace_filter interface returns error in case the filter
> did not match:
> 
>   # echo krava > set_ftrace_filter
>   bash: echo: write error: Invalid argument
> 
> Changing both ftrace_set_filter and ftrace_set_notrace functions
> to return zero if the filter was applied correctly or -E* values
> in case of error.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
