Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab2JXDVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:21:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:54280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab2JXDVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:21:20 -0400
Subject: Re: [RFC PATCH 1/3] dmaengine: add dma_get_channel_caps()
From: Vinod Koul <vkoul@infradead.org>
To: Dan Williams <djbw@fb.com>
Cc: vinod.koul@intel.com, Matt Porter <mporter@ti.com>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
In-Reply-To: <CAA9_cmdVfbO+T0iSEf4uTPcejx1Mx+aQ5LidYZkJ89dVR=ydXw@mail.gmail.com>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
	 <1350615088-14562-2-git-send-email-mporter@ti.com>
	 <CAA9_cmdVfbO+T0iSEf4uTPcejx1Mx+aQ5LidYZkJ89dVR=ydXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 08:39:01 +0530
Message-ID: <1351048141.5263.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 15:54 -0700, Dan Williams wrote:
> > +struct dmaengine_chan_caps {
> > +       enum dmaengine_apis ops;
> > +       int seg_nr;
> > +       int seg_len;
> > +};
> 
> This makes sense for the potentially dynamic capability properties
> that get set after configuration, but why do we need the operation
> types here?  They can be retrieved from the parent device. 
I was thinking that each channel can have different capabilities.
You can assign one channel for mempcy operations exclusively and some
others for slave usage exclusively.
I believe some h/w do have such assignment so would help in doing that.

-- 
Vinod Koul
Intel Corp.

