Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0LXLgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:36:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:22920 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab0LXLgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:36:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,223,1291622400"; 
   d="scan'208";a="871572390"
Date: Fri, 24 Dec 2010 12:36:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 3/4] regulator MAX8998/LP3974: Support DVS-GPIO.
Message-ID: <20101224113632.GG27832@sortiz-mobl>
References: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
 <1293094419-24221-4-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293094419-24221-4-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Thu, Dec 23, 2010 at 05:53:38PM +0900, MyungJoo Ham wrote:
> The previous driver did not support BUCK1-DVS3, BUCK1-DVS4, and
> BUCK2-DVS2 modes. This patch adds such modes and an option to block
> setting buck1/2 voltages out of the preset values.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
I'm fine with the MFD changes, and I suppose it would make sense for me to
carry this patch. I'll do so once I get Liam or Mark ACK on it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
