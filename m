Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab1IOPH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:07:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:41420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933899Ab1IOPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48774831"
Date: Thu, 15 Sep 2011 17:10:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, David Jander <david@protonic.nl>
Subject: Re: [PATCH 0/6] mc13783 cleanup
Message-ID: <20110915151033.GD32263@sortiz-mobl>
References: <20110824132740.GA28197@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110824132740.GA28197@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Wed, Aug 24, 2011 at 03:27:40PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> this series removes the long obsolte mc13783 API after fixing all
> remaining users.
> 
> The patches touch many subsystems and have some interdependencies:
> 
>  - patches 3 and 5 depend on patch 2
>  - patch 6 depends on patches 1-5
> 
> So we have to think about how to merge them when everyone is OK that
> they are merged.
I am merging them, unless someone objects here.
I have applied all 6 patches now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
