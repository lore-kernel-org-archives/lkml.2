Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1EBPPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:15:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:33928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1EBPPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,303,1301900400"; 
   d="scan'208";a="916965055"
Date: Mon, 2 May 2011 17:15:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, dwmw2@infradead.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 11/14] power_supply: max8925: use platform_data from
 cell
Message-ID: <20110502151513.GD8222@sortiz-mobl>
References: <2011041801>
 <1303135451-26362-12-git-send-email-haojian.zhuang@marvell.com>
 <20110418214919.GA21160@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418214919.GA21160@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian, Anton,

On Tue, Apr 19, 2011 at 01:49:19AM +0400, Anton Vorontsov wrote:
> On Mon, Apr 18, 2011 at 10:04:08PM +0800, Haojian Zhuang wrote:
> > Avoid to get platform_data from parent device. Get it from mfd cell
> > device instead.
> > 
> > Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> > Cc: Anton Vorontsov <cbou@mail.ru>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > ---
> 
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Thanks, patch applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
