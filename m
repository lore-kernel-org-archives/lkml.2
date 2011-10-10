Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1JJTCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:02:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:63228 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab1JJTCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,518,1312182000"; 
   d="scan'208";a="60761779"
Date: Mon, 10 Oct 2011 21:05:29 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 3/6] MFD: twl6040: function to query the vibra status
 for clients
Message-ID: <20111010190527.GE2592@sortiz-mobl>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
 <1316760584-27426-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316760584-27426-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Sep 23, 2011 at 09:49:41AM +0300, Peter Ujfalusi wrote:
> If the client only interested, if any of the vibra channels enabled, or
> if any of the channels are set to receive audio data via PDM.
> 
> This function targets mainly the vibra driver, so it can check if it is
> allowed to execute effects ot not.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

I assume those 2 go upstream through the ASoC tree, right ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

