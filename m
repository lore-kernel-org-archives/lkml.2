Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2GPN23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:28:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:59483 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2GPN22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193386857"
Date: Mon, 16 Jul 2012 15:28:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix checking return value of regmap_read()
Message-ID: <20120716132831.GG20652@sortiz-mobl>
References: <1341970074.11561.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341970074.11561.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Jul 11, 2012 at 09:27:54AM +0800, Axel Lin wrote:
> Check the return value of regmap_read() rather than the read value.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/88pm800.c |   16 +++++++++-------
>  drivers/mfd/88pm805.c |    5 +++--
>  2 files changed, 12 insertions(+), 9 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
