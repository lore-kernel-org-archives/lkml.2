Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0LIGb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:31:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46756 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0LIGb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:31:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] poll: fix a typo in comment
Cc: kosaki.motohiro@jp.fujitsu.com, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291868401-32237-1-git-send-email-namhyung@gmail.com>
References: <1291868401-32237-1-git-send-email-namhyung@gmail.com>
Message-Id: <20101209152800.C7A0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Dec 2010 15:31:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  include/linux/poll.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/poll.h b/include/linux/poll.h
> index 56e76af78102..afd3375e58ee 100644
> --- a/include/linux/poll.h
> +++ b/include/linux/poll.h
> @@ -57,7 +57,7 @@ struct poll_table_entry {
>  };
>  
>  /*
> - * Structures and helpers for sys_poll/sys_poll
> + * Structures and helpers for sys_select/sys_poll
>   */

Now we don't have sys_poll() and sys_poll() function. At least they
are hidden by SYSCALL_DEFINEx() macro.

so probably, "for select/poll syscall" is better explanation?



>  struct poll_wqueues {
>  	poll_table pt;
> -- 
> 1.7.3.3.400.g93cef
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



