Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab1EYIch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:32:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:40572 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab1EYIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:32:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="4441092"
Subject: Re: [PATCH resend] dmaengine/dw_dmac: Update maintainer-ship
From: "Koul, Vinod" <vinod.koul@intel.com>
To: =?ISO-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        armando.visconti@st.com, viresh.linux@gmail.com
In-Reply-To: <BANLkTikTEEgu_uq_ee=aZW+G7gfJaPrrWQ@mail.gmail.com>
References: <fd5b04cbce5c1051dee3faf0719f6db3ee706e60.1306226016.git.viresh.kumar@st.com>
	 <1306226815.28926.322.camel@vkoul-udesk3>
	 <BANLkTikTEEgu_uq_ee=aZW+G7gfJaPrrWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 13:29:08 +0530
Message-ID: <1306310348.30236.92.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 09:30 -0700, Håvard Skinnemoen wrote:
> On Tue, May 24, 2011 at 1:46 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
> > On Tue, 2011-05-24 at 14:04 +0530, Viresh Kumar wrote:
> >> Nobody is currently maintaining dw_dmac. We are using dw_dmac for SPEAr13xx and
> >> are currently maintaining it. After discussing with Vinod, sending this patch to
> >> update maintainer-ship of dw_dmac.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> >> ---
> >>  MAINTAINERS                |    7 +++++++
> >>  drivers/dma/dw_dmac.c      |    2 ++
> >>  drivers/dma/dw_dmac_regs.h |    1 +
> >>  include/linux/dw_dmac.h    |    1 +
> >>  4 files changed, 11 insertions(+), 0 deletions(-)
> > Am okay if Havard is...
> 
> Hard to say based on the diffstat alone, but the patch I found in the
> archives looks sane, so it's ok with me. Hopefully it's the same one
> ;-)
> 
> Havard
My bad, should have send the whole patch :(

Applied with Ack from Havard.

Havard, would you like to update your email in dma files as well?
I am planning to send merge request tomorrow.

-- 
~Vinod

