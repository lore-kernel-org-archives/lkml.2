Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0HIOJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:09:31 -0400
Received: from exht1.emulex.com ([138.239.113.183]:49483 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756424Ab0HIOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:09:30 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2010 10:09:30 EDT
Message-ID: <4C600AAE.8030507@emulex.com>
Date: Mon, 9 Aug 2010 10:03:26 -0400
From: James Smart <james.smart@emulex.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] lpfc: change spin_lock_irq() to spin_lock()
References: <20100807221517.GC9031@bicker>
In-Reply-To: <20100807221517.GC9031@bicker>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dan Carpenter wrote:
> In lpfc_cleanup_pending_mbox() we already have IRQs disabled so we don't
> need to disable them again.
> 
> Also in lpfc_sli_intr_handler() there is a typo where it has
> spin_unlock_irq() instead of just spin_unlock().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c

Acked-by: James Smart <james.smart@emulex.com>

Thank You.

-- james s
