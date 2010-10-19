Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0JSWUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:20:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab0JSWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:20:11 -0400
Date: Tue, 19 Oct 2010 15:20:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: printk: Fix a coding style issue.
Message-Id: <20101019152008.f1223d24.akpm@linux-foundation.org>
In-Reply-To: <1287512341-13130-1-git-send-email-ralf.thielow@googlemail.com>
References: <1287512341-13130-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 20:19:01 +0200
Ralf Thielow <ralf.thielow@googlemail.com> wrote:

> Fixed a coding style issue of "do_syslog" in
> case of open or close the log.
> 
> Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
> ---
>  kernel/printk.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 8fe465a..3539744 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -273,9 +273,8 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  		return error;
>  
>  	switch (type) {
> -	case SYSLOG_ACTION_CLOSE:	/* Close log */
> -		break;
>  	case SYSLOG_ACTION_OPEN:	/* Open log */
> +	case SYSLOG_ACTION_CLOSE:	/* Close log */
>  		break;
>  	case SYSLOG_ACTION_READ:	/* Read from log */
>  		error = -EINVAL;

I don't really think that the code needed fixing there?
