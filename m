Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1IZKBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:01:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:19764 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1IZKBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:01:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,442,1312182000"; 
   d="scan'208";a="55614667"
Date: Mon, 26 Sep 2011 12:04:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] mfd/mc13xxx: fix a sparse warning about mc13xxx_chipname
 not being declared
Message-ID: <20110926100441.GG32263@sortiz-mobl>
References: <1316807502-27374-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1316807502-27374-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Fri, Sep 23, 2011 at 09:51:42PM +0200, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mfd/mc13xxx-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
