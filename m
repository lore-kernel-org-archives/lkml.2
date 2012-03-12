Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2CLQva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:51:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53382 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2CLQv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:51:28 -0400
Date: Mon, 12 Mar 2012 17:51:01 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] amd64_edac: Fix the rank number of pages count
Message-ID: <20120312165101.GF7255@aftab>
References: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
 <1331556515-7902-4-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331556515-7902-4-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:48:34AM -0300, Mauro Carvalho Chehab wrote:
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/amd64_edac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index ea7eb9a..d74bcd3 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2227,7 +2227,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  		for (j = 0; j < pvt->channel_count; j++) {
>  			csrow->channels[j].dimm->mtype = mtype;
>  			csrow->channels[j].dimm->edac_mode = edac_mode;
> -			csrow->channels[j].dimm->nr_pages = nr_pages / pvt->channel_count;
> +			csrow->channels[j].dimm->nr_pages = nr_pages;
>

This one has, again no commit message :( but nevertheless, I already
have a fix queued:

http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=commitdiff;h=98c35aebc9734c1c970e3b4654dc8bd2e34f2a20

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
