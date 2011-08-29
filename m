Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1H2MO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:14:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:22471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1H2MOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:14:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43238785"
Subject: Re: [PATCH] dmatest: make dmatest threads freezable
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAA9_cmf=t_n7bKT=eS7oFSyBd2wJGiabVpcVjp2d3jN_wKRnyg@mail.gmail.com>
References: <Pine.LNX.4.64.1108181648370.5245@axis700.grange>
	 <1314282450.1606.43.camel@vkoul-udesk3>
	 <CAA9_cmf=t_n7bKT=eS7oFSyBd2wJGiabVpcVjp2d3jN_wKRnyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 17:43:09 +0530
Message-ID: <1314619989.1606.131.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 15:42 -0700, Dan Williams wrote:
> On Thu, Aug 25, 2011 at 7:27 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
> > On Thu, 2011-08-18 at 16:50 +0200, Guennadi Liakhovetski wrote:
> >> Making dmatest threads freezable allows its use for system PM testing.
> >>
> >> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Looks good to me, Dan if you give me your ack, I will carry this in my
> > tree
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
Applied, Thanks

--
~Vinod

