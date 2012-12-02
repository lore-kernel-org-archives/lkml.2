Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2LBXmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 18:42:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:33553 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2LBXmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 18:42:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,202,1355126400"; 
   d="scan'208";a="256316629"
Date: Mon, 3 Dec 2012 00:42:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm5102: Add tuning for revision B
Message-ID: <20121202234220.GY3176@sortiz-mobl>
References: <1354416107-17481-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1354416107-17481-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354416107-17481-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Dec 02, 2012 at 11:41:47AM +0900, Mark Brown wrote:
> Evaluation of revision B of WM5102 suggests updates to the register patch
> for optimal performance, and make this the default behaviour for new
> devices.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
Applied as well, probably the last patch I'll apply to my for-next branch for
3.8.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
