Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1G0Jvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:51:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:65287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1G0Jvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="34999369"
Date: Wed, 27 Jul 2011 11:52:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: avoid two assignments if failures happen in
 tps65910_i2c_probe
Message-ID: <20110727095248.GB26275@sortiz-mobl>
References: <alpine.LNX.2.00.1107132319020.22281@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107132319020.22281@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Wed, Jul 13, 2011 at 11:22:26PM +0200, Jesper Juhl wrote:
> In drivers/mfd/tps65910.c:tps65910_i2c_probe() there's potential for a
> tiny optimization.
> 
> We assign to init_data->irq and init_data->irq_base long before we
> need them, and there are two potential exits from the function before
> they are needed.
> 
> Moving the assignments below these two potential exits means we
> completely avoid doing them in these two (failure) cases.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
