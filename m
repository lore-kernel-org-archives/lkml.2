Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0DTOb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:31:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:49771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab0DTOb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:31:57 -0400
Date: Tue, 20 Apr 2010 16:31:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/5] uml: Remove unused variable from line driver
In-Reply-To: <f430193946dbd11791e8fb5bef2e4a8e68393828.1271713955.git.jan.kiszka@web.de>
Message-ID: <alpine.LNX.2.00.1004201631440.7579@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <f430193946dbd11791e8fb5bef2e4a8e68393828.1271713955.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010, Jan Kiszka wrote:

> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> ---
>  arch/um/drivers/line.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
> index 7a656bd..7f7338c 100644
> --- a/arch/um/drivers/line.c
> +++ b/arch/um/drivers/line.c
> @@ -19,7 +19,6 @@ static irqreturn_t line_interrupt(int irq, void *data)
>  {
>  	struct chan *chan = data;
>  	struct line *line = chan->line;
> -	struct tty_struct *tty;
>  
>  	if (line)
>  		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
