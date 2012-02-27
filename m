Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2B0JOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:14:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:2011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2B0JOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:14:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="115186897"
Subject: Re: [PATCH 0/4] dmaengine: i.MX DMA series.
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux@arm.linux.org.uk, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACKLOr0ZhN-7a=n5KvQdakbAkMXN0r53yzHQuJKfNRX3-T=22g@mail.gmail.com>
References: <1328884300-18801-1-git-send-email-javier.martin@vista-silicon.com>
	 <CACKLOr1Gn_NR8HPhmyK6DW9W+7CGG8y7yoZm6PE3bH2zt6Ej-g@mail.gmail.com>
	 <1329916892.24656.110.camel@vkoul-udesk3>
	 <CACKLOr0ZhN-7a=n5KvQdakbAkMXN0r53yzHQuJKfNRX3-T=22g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 14:46:43 +0530
Message-ID: <1330334203.24656.133.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 09:20 +0100, javier Martin wrote:
> Please, note that if for whatever reason you don't apply patch 2 you
> must not apply patch 3 either. Because, as I stated, it depends
> completely on patch 2. 
Then you should resend teh series after dropping 2.
-- 
~Vinod

