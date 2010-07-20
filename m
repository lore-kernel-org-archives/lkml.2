Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330Ab0GTPKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:10:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:33212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534Ab0GTPKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:10:12 -0400
Date: Tue, 20 Jul 2010 17:10:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Jing Huang <huangj@brocade.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Krishna Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/16] trivial: use ARRAY_SIZE
In-Reply-To: <1277726105-24600-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.LNX.2.00.1007201709500.4741@pobox.suse.cz>
References: <1277726105-24600-1-git-send-email-segooon@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/scsi/bfa/bfa_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
> index 3a7b3f8..d845506 100644
> --- a/drivers/scsi/bfa/bfa_core.c
> +++ b/drivers/scsi/bfa/bfa_core.c
> @@ -335,7 +335,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
>  		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
>  	};
>  
> -	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
> +	*npciids = ARRAY_SIZE(__pciids);
>  	*pciids = __pciids;
>  }

Doesn't seem to be in linux-next as of today. I have applied the patch to 
trivial queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
