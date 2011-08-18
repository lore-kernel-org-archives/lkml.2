Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1HRWuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:50:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38024 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab1HRWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:50:38 -0400
X-Sasl-enc: 3Fa2a9Pyhfj3BK/mRvdRHW53c0tpAeS6m6bzPbCAuuFw 1313707837
Date: Thu, 18 Aug 2011 11:26:15 -0700
From: Greg KH <greg@kroah.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Message-ID: <20110818182615.GA18567@kroah.com>
References: <1313664271-694-1-git-send-email-gadiyar@ti.com>
 <CAP05o4J01FpphHgV5tpkFGNfTBbjhtScKjWZm4iLi3H1V=EKDQ@mail.gmail.com>
 <20110818112454.GS14514@legolas.emea.dhcp.ti.com>
 <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D3ADE54@dbde03.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D3ADE54@dbde03.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 05:14:17PM +0530, Gadiyar, Anand wrote:
> Balbi, Felipe wrote:
> > HI,
> > 
> > On Thu, Aug 18, 2011 at 04:52:22PM +0530, Munegowda, Keshava wrote:
> > > On Thu, Aug 18, 2011 at 4:14 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> > > > This code section seems to have been accidentally copy pasted.
> > > > It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
> > > > register and prevents the TLL mode from working correctly.
> > > >
> > > > Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> > > > Cc: Keshava Munegowda <keshava_mgowda@ti.com>
> > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > Sam, you can apply this one:
> > 
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > 
> > But I think it needs to be resent with Cc: stable@kernel.org
> 
> I'm trying to avoid "Cc: stable@kernel.org" since RMK complained about
> this on the Linux ARM kernel list. [1]

Why would he do that?  You need to put the Cc: in the signed off by
area, and all will be fine.  If you just put it in your email, you will
get an automated email from me telling you to go read
Documentation/stable_kernel_rules.txt which tells you exactly how to do
this properly.

greg k-h
