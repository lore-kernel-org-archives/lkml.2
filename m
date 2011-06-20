Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1FTOCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:02:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:56250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1FTOCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:02:33 -0400
Date: Mon, 20 Jun 2011 16:02:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] stop_machine.h: "disables preeempt" -> "disables
 preemption"
In-Reply-To: <1308477022-13299-1-git-send-email-j.neuschaefer@gmx.net>
Message-ID: <alpine.LNX.2.00.1106201552420.11049@pobox.suse.cz>
References: <1308477022-13299-1-git-send-email-j.neuschaefer@gmx.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Jonathan Neuschäfer wrote:

> Use the noun instead of a misspelled verb.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  include/linux/stop_machine.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> index 092dc9b..2d3f0b1 100644
> --- a/include/linux/stop_machine.h
> +++ b/include/linux/stop_machine.h
> @@ -94,7 +94,7 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
>   * stop_machine "Bogolock": stop the entire machine, disable
>   * interrupts.  This is a very heavy lock, which is equivalent to
>   * grabbing every spinlock (and more).  So the "read" side to such a
> - * lock is anything which disables preeempt.
> + * lock is anything which disables preemption.

If there wouldn't be the typo, I'd gladly keep the old version there. But 
with the typo being there anyway ... applied.

-- 
Jiri Kosina
SUSE Labs
