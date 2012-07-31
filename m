Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2GaGpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:45:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:57745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab2GaGpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="179644148"
Subject: Re: [PATCH] dma: imx-dma: Fix kernel crash due to missing clock
 conversion
From: Vinod Koul <vinod.koul@linux.intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com
In-Reply-To: <CACKLOr1BHZR+d8UwSCtnEhO=CnrmGBsD8Tt_KtrBCmWEvE4Z=Q@mail.gmail.com>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
	 <1343359050.1726.9033.camel@vkoul-udesk3>
	 <CAOMZO5DCEgjw1cyCV5nP-aoksboF2HFQ_emzSUXRCgGAGNuqUg@mail.gmail.com>
	 <CACKLOr1dLkVwy4YPMfCGL-GzLZT8BfdFmujeqUPO=xwJ73Xt1A@mail.gmail.com>
	 <CACKLOr1BHZR+d8UwSCtnEhO=CnrmGBsD8Tt_KtrBCmWEvE4Z=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jul 2012 12:16:40 +0530
Message-ID: <1343717200.1726.14407.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 14:38 +0200, javier Martin wrote:
> On 30 July 2012 13:31, javier Martin <javier.martin@vista-silicon.com> wrote:
> > Hi,
> >
> > On 27 July 2012 13:37, Fabio Estevam <festevam@gmail.com> wrote:
> >> On Fri, Jul 27, 2012 at 12:17 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> >>
> >>>> Reported-by: Javier Martin <javier.martin@vista-silicon.com>
> >>>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> >>> Applied thanks (to fixes-for 3.7)
> >>
> >> You mentioned that you would also copy stable. Would it be applied
> >> into stable soon too?
Once it hits the linus's tree, yes.
> >
> > I agree with Fabio, this patch should also be applied to stable.

> I almost forgot,
> Vinod, I am a bit confused about the branch you've used to merge this
> patch. The branch is called 'fixes_for-3.7'. Does this mean that the
> patch won't be applied for 3.6? I've seen you've added the line ' Cc:
> stable@vger.kernel.org' which ensures the patch will appear in 3.5.X
> but what about 3.6?
This patch will appear in 3.7-rc2 when I send the fixes to Linus post
rc1,  I guess early next week.

Stable guys will pick this and apply to 3.6.X version.

-- 
~Vinod

