Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1LBHTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 02:19:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:55345 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1LBHTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 02:19:42 -0500
Message-ID: <4ED87C02.6030007@axboe.dk>
Date: Fri, 02 Dec 2011 08:19:30 +0100
From: Jens Axboe <jens@axboe.dk>
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] fs/splice: export splice_to_pipe to GPL modules
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-4-git-send-email-mathieu.desnoyers@efficios.com>
In-Reply-To: <1322775683-8741-4-git-send-email-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-01 22:41, Mathieu Desnoyers wrote:
> The LTTng driver needs this symbol exported because it implements its
> own splice actor.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: linux-kernel@vger.kernel.org
> CC: Greg KH <greg@kroah.com>
> ---
>  fs/splice.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index fa2defa..9eb15b5 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -263,6 +263,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(splice_to_pipe);

The rest of the splice symbols are regular exports, please do the same
for this one. Thanks.

-- 
Jens Axboe

