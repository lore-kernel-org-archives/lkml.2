Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0KATpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:45:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:40558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab0KATpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:45:19 -0400
Date: Mon, 1 Nov 2010 15:45:18 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/22] trivial: fix typos concerning "already"
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1011011544590.15851@pobox.suse.cz>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Uwe Kleine-König wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/scsi/bfa/bfa_fcpim.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
> index 33c8dd5..aabbf3d 100644
> --- a/drivers/scsi/bfa/bfa_fcpim.c
> +++ b/drivers/scsi/bfa/bfa_fcpim.c
> @@ -2092,7 +2092,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
>  
>  	case BFA_IOIM_SM_ABORT:
>  		/**
> -		 * IO is alraedy being cleaned up implicitly
> +		 * IO is already being cleaned up implicitly
>  		 */
>  		ioim->io_cbfn = __bfa_cb_ioim_abort;

I have folded the whole series into one patch and applied. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
