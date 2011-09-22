Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1IVQuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:50:18 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55011
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174Ab1IVQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:50:16 -0400
Date: Thu, 22 Sep 2011 12:50:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Message-ID: <20110922165014.GA12505@infradead.org>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
 <1316691000.10571.6.camel@dabdike>
 <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:41:36AM -0700, Luben Tuikov wrote:
> Allow expander table-to-table attachments for
> expanders that support it.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
> ?drivers/scsi/libsas/sas_expander.c |?? 20 ++++++++++++++------
> ?include/scsi/libsas.h????????????? |??? 3 +++
> ?include/scsi/sas.h???????????????? |?? 14 ++++++++++++--
> ?3 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f84084b..e8d0115 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct domain_device *dev,
> ???? dev->ex_dev.ex_change_count = be16_to_cpu(rg->change_count);
> ???? dev->ex_dev.max_route_indexes = be16_to_cpu(rg->route_indexes);
> ???? dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);

This looks completely garbled to me.

