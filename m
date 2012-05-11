Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2EKJdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:33:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:48500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab2EKJdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98895540"
Date: Fri, 11 May 2012 11:42:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 3/4] power_supply/MFD: twl4030_charger: Allow charger to
 control the regulator that feeds it.
Message-ID: <20120511094249.GE1214@sortiz-mobl>
References: <20120508213518.2844.95446.stgit@notabene.brown>
 <20120508214040.2844.5662.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508214040.2844.5662.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, May 09, 2012 at 07:40:40AM +1000, NeilBrown wrote:
> The charger needs usb3v1 to be running, so add a new consumer to
> keep it running.
> 
> This allows the charger to draw current even when the USB driver has
> powered down.
> 
> Acked-by: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
