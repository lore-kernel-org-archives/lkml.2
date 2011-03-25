Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1CYUiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:38:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:56506 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1CYUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:38:06 -0400
Message-ID: <4D8CFD22.6070709@windriver.com>
Date: Fri, 25 Mar 2011 15:37:54 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH] kdb: add usage string of 'per_cpu' command
References: <1299067738-25680-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1299067738-25680-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2011 20:37:54.0025 (UTC) FILETIME=[8442CD90:01CBEB2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 06:08 AM, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  kernel/debug/kdb/kdb_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> index bd3e8e29caa3..2486021ff5d9 100644
> --- a/kernel/debug/kdb/kdb_main.c
> +++ b/kernel/debug/kdb/kdb_main.c
> @@ -2892,7 +2892,7 @@ static void __init kdb_inittab(void)
>  	  "Send a signal to a process", 0, KDB_REPEAT_NONE);
>  	kdb_register_repeat("summary", kdb_summary, "",
>  	  "Summarize the system", 4, KDB_REPEAT_NONE);
> -	kdb_register_repeat("per_cpu", kdb_per_cpu, "",
> +	kdb_register_repeat("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
>  	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
>  	kdb_register_repeat("grephelp", kdb_grep_help, "",
>  	  "Display help on | grep", 0, KDB_REPEAT_NONE);


Thanks,

I added this to the queued patches.

Jason.
