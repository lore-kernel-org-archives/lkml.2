Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0LTNLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:11:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:20185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564Ab0LTNLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:11:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,202,1291622400"; 
   d="scan'208";a="585409079"
Date: Mon, 20 Dec 2010 14:11:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] mfd: Use dummy_irq_chip for tc3589x
Message-ID: <20101220131117.GH11095@sortiz-mobl>
References: <20101220120918.GF11095@sortiz-mobl>
 <CEE6BB42CAD6E947908279175AF8470A075EFE20EB@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A075EFE20EB@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 01:35:56PM +0100, Linus WALLEIJ wrote:
> [Samuel]
> 
> > This also converts tc3589x to the new irq API.
> > 
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> > 
> > Linus, this should go through your ux500-core branch as this is where
> > the
> > tc3589x rename happens.
> 
> OK applied and pushed to ux500-core, you can drop this
> tc35x stuff off the MFD tree now..
Done, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
