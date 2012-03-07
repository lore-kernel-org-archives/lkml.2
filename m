Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2CGILR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:11:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:34948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab2CGILQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:11:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118540736"
Subject: Re: [PATCH 01/14] dmaengine: imx-dma: merge old dma-v1.c with
 imx-dma.c
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        dan.j.williams@intel.com
In-Reply-To: <CACKLOr0iBSMd8hNdmeAiMWgyyUb_b1=5n47N97hu9EP2Zu9OsQ@mail.gmail.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
	 <1330964196-32623-2-git-send-email-javier.martin@vista-silicon.com>
	 <1331102571.24656.324.camel@vkoul-udesk3>
	 <CACKLOr0iBSMd8hNdmeAiMWgyyUb_b1=5n47N97hu9EP2Zu9OsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 13:45:58 +0530
Message-ID: <1331108158.24656.330.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 08:52 +0100, javier Martin wrote:
> Hi Vinod,
> 
> On 7 March 2012 07:42, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Mon, 2012-03-05 at 17:16 +0100, Javier Martin wrote:
> > Sascha,
> > Are there any more users of dmac in mach-imx?
> 
> No, there are no other users of mach-imx. In fact, it was Sascha's
> idea to make this merge [1].
Then please move the file in 1st patch, also it would be easily clear
what parts are added, deleted and moved.

Otherwise the series looks fine except that it needs to have a better
changelog on why you are removing certain field/struct. It helps to
document the motivation of doing certain change, you will find that you
wont remember that six months down the line :)

Also I am looking for Tested-By from people who have use imx-dma.

> 
> > If not then why not move the code, rather than copy.
> > If yes can we move them as well?
> 
> I do remove the code in mach-imx in PATCH 14/14. I considered it was
> better doing this in the last patch to keep the old code available
> during the whole development process.
> 
> [1] https://lkml.org/lkml/2012/2/9/171
> 


-- 
~Vinod

