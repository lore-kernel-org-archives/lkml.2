Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0LHBUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:20:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab0LHBUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:20:34 -0500
Date: Wed, 8 Dec 2010 01:20:30 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH 2/4] dmaengine/dw_dmac: allow src/dst masters to be
 configured at runtime
Message-ID: <20101208012030.GD7226@pulham.picochip.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
 <1290510371-23077-3-git-send-email-jamie@jamieiles.com>
 <AANLkTi=Acre04XiLAAKN4fXuHsgY-gCDA=Yus92zmf_5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Acre04XiLAAKN4fXuHsgY-gCDA=Yus92zmf_5@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 05:03:24PM -0800, Dan Williams wrote:
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
Hi Dan,

Apologies, I was sure I'd ran all of these through checkpatch but it must have 
been a different series. Respin of patches 1 and 2 to follow...

Jamie
