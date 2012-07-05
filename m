Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab2GEOhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:37:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:17696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab2GEOhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:37:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164369713"
Date: Thu, 5 Jul 2012 16:48:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, s-guiriec@ti.com
Subject: Re: [PATCH 1/3] MFD: palmas fix regulator pdata missing
Message-ID: <20120705144843.GE18200@sortiz-mobl>
References: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
 <1340368581-11882-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340368581-11882-2-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graeme,

On Fri, Jun 22, 2012 at 01:36:18PM +0100, Graeme Gregory wrote:
> Due to a merge error the section of code passing the pdata for the
> regulator driver to the mfd_add_devices via the children structure
> was missing. This corrects this problem.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/mfd/palmas.c |    3 +++
>  1 file changed, 3 insertions(+)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
