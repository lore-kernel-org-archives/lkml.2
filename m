Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0LHGmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:42:03 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:54275 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0LHGmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:42:00 -0500
Subject: Re: [PATCH 2/4] dmaengine/dw_dmac: allow src/dst masters to be
 configured at runtime
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Jamie Iles <jamie.iles@picochip.com>
In-Reply-To: <AANLkTi=Acre04XiLAAKN4fXuHsgY-gCDA=Yus92zmf_5@mail.gmail.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
	 <1290510371-23077-3-git-send-email-jamie@jamieiles.com>
	 <AANLkTi=Acre04XiLAAKN4fXuHsgY-gCDA=Yus92zmf_5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 08 Dec 2010 07:41:50 +0100
Message-ID: <1291790510.2794.1.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2010 06:41:51.0900 (UTC) FILETIME=[FF1AB5C0:01CB96A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 17:03 -0800, Dan Williams wrote: 
> [ adding Hans ]
> 
> On Tue, Nov 23, 2010 at 3:06 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> > Some platforms have flexible mastering capabilities and this needs
> > to be selected at runtime. If the platform has specified private
> > data in the form of the dw_dma_slave then fetch the source and
> > destination masters from here. If this isn't present, default to
> > the previous of 0 and 1.
> >
> > Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
> > ---
> 
> Hi James,
> 
> Please integrate checkpatch into your workflow and fixup the trivial
> whitespace damage (tabs-to-spaces) reports.
> 
> Also noticed this on patch 1/4 of this series.
> 
> Hans, can you provide an acked-by for this series when James reposts it?

The arch stuff, or the DMA stuff? I do not track DMA changes, so I don't
think my acked-by would be very valuable.

I didn't see any updated arch patches, was I supposed to see that?

-- 
Hans-Christian Egtvedt

