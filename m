Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2EFGdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 02:33:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:32867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2EFGdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 02:33:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137466839"
Date: Sun, 6 May 2012 09:34:40 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 4/4] power-supply: smb347-charger: convert to regmap API
Message-ID: <20120506063440.GF31494@intel.com>
References: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
 <1334566121-8243-4-git-send-email-mika.westerberg@linux.intel.com>
 <20120505125211.GA31577@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505125211.GA31577@lizard>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 05:52:11AM -0700, Anton Vorontsov wrote:
> 
> I fixed this by the following change:
> 
> diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
> index 1f27d21..cf31b31 100644
> --- a/drivers/power/smb347-charger.c
> +++ b/drivers/power/smb347-charger.c
> @@ -459,7 +459,8 @@ static int smb347_set_voltage_limits(struct smb347_charger *smb)
>  static int smb347_set_temp_limits(struct smb347_charger *smb)
>  {
>  	bool enable_therm_monitor = false;
> -	int ret, val;
> +	int ret = 0;
> +	int val;
>  
>  	if (smb->pdata->chip_temp_threshold) {
>  		val = smb->pdata->chip_temp_threshold;
> 
> Please check if that's all OK.

Looks ok to me. Thanks for fixing it.
