Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab1GDReS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:34:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:16705 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab1GDReR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:34:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,474,1304319600"; 
   d="scan'208";a="21431146"
Date: Mon, 4 Jul 2011 19:34:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] mfd: remove dead code from
 drivers/mfd/max8997-irq.c:get_i2c()
Message-ID: <20110704173444.GS3021@sortiz-mobl>
References: <alpine.LNX.2.00.1107022235380.16316@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107022235380.16316@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Sat, Jul 02, 2011 at 10:38:11PM +0200, Jesper Juhl wrote:
> We either hit one of the case's or the default in the switch statement
> in get_i2c(), so the 'return ERR_PTR(-EINVAL);' at the end of the
> function is just dead code - remove it.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
