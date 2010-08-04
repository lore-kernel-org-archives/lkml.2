Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0HDNIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:08:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:49155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679Ab0HDNIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:08:50 -0400
Date: Wed, 4 Aug 2010 15:08:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo "choosed" -> "chosen"
In-Reply-To: <1280516567-25754-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1008041508400.29919@pobox.suse.cz>
References: <4C52F6C1.5090207@mvista.com> <1280516567-25754-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010, Uwe Kleine-König wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  fs/ext4/mballoc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 12b3bc0..0e83dfd 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2704,7 +2704,7 @@ void exit_ext4_mballoc(void)
>  
>  
>  /*
> - * Check quota and mark choosed space (ac->ac_b_ex) non-free in bitmaps
> + * Check quota and mark chosen space (ac->ac_b_ex) non-free in bitmaps
>   * Returns 0 if success or error code
>   */
>  static noinline_for_stack int

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
