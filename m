Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab0LJFlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 00:41:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56717 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0LJFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 00:41:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH UPDATED] poll: fix a typo in comment
Cc: kosaki.motohiro@jp.fujitsu.com, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291913827-13558-1-git-send-email-namhyung@gmail.com>
References: <AANLkTimUJ0mOkNe+ATAxDze_zHbWU8R1cJinEfX98Azw@mail.gmail.com> <1291913827-13558-1-git-send-email-namhyung@gmail.com>
Message-Id: <20101210144111.C7B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Dec 2010 14:41:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Convert duplicated sys_poll to select. As Kosaki suggests, sys_poll() and
> sys_select() are now hidden by SYSCALL_DEFINEx() macros so it would be
> better to use plain select/poll syscall name.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thank you.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

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
> + * Structures and helpers for select/poll syscall
>   */
>  struct poll_wqueues {
>  	poll_table pt;
> -- 
> 1.7.3.3.400.g93cef
> 



