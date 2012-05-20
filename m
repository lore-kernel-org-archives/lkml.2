Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2ETTEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 15:04:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39785 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2ETTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 15:04:40 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.46.74
Date: Sun, 20 May 2012 12:04:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
        a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]ipc:fixed spacing issues in coding style.
Message-ID: <20120520190430.GB6475@leaf>
References: <1337511673-3485-1-git-send-email-ahiliation@yahoo.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337511673-3485-1-git-send-email-ahiliation@yahoo.co.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 04:31:13PM +0530, Jeffrin Jose wrote:
> Fixed spacing issues related to different operators
> like * and : found by checkpatch.pl tool in ipc/sem.c
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

All three of the spacing fixes in this patch look correct.
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

However, I see one instance of another type of spacing issue in the
patch context:

> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -964,7 +964,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
>  		up_read(&sem_ids(ns).rw_mutex);
>  		if (copy_to_user (arg.__buf, &seminfo, sizeof(struct seminfo))) 

copy_to_user should not have a space before its open parenthesis.

- Josh Triplett
