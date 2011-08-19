Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1HSFMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:12:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46443 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1HSFMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:12:39 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Greg KH <greg@kroah.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Fri, 19 Aug 2011 10:42:27 +0530
Subject: RE: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Thread-Topic: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Thread-Index: Acxd+UIkvxno0YgARSWzyBegELGyoAAMtxfw
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D07290A@dbde03.ent.ti.com>
References: <1313664271-694-1-git-send-email-gadiyar@ti.com>
 <CAP05o4J01FpphHgV5tpkFGNfTBbjhtScKjWZm4iLi3H1V=EKDQ@mail.gmail.com>
 <20110818112454.GS14514@legolas.emea.dhcp.ti.com>
 <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D3ADE54@dbde03.ent.ti.com>
 <20110818182615.GA18567@kroah.com>
In-Reply-To: <20110818182615.GA18567@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 18, 2011 at 05:14:17PM +0530, Gadiyar, Anand wrote:
> > Balbi, Felipe wrote:
> > > HI,
> > > 
> > > On Thu, Aug 18, 2011 at 04:52:22PM +0530, Munegowda, Keshava wrote:
> > > > On Thu, Aug 18, 2011 at 4:14 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> > > > > This code section seems to have been accidentally copy pasted.
> > > > > It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
> > > > > register and prevents the TLL mode from working correctly.
> > > > >
> > > > > Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> > > > > Cc: Keshava Munegowda <keshava_mgowda@ti.com>
> > > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > 
> > > Sam, you can apply this one:
> > > 
> > > Acked-by: Felipe Balbi <balbi@ti.com>
> > > 
> > > But I think it needs to be resent with Cc: stable@kernel.org
> > 
> > I'm trying to avoid "Cc: stable@kernel.org" since RMK complained about
> > this on the Linux ARM kernel list. [1]
> 
> Why would he do that?  You need to put the Cc: in the signed off by
> area, and all will be fine.  If you just put it in your email, you will
> get an automated email from me telling you to go read
> Documentation/stable_kernel_rules.txt which tells you exactly how to do
> this properly.

Thanks for clearing that up.

I'm resending with Felipe's ack and CCing stable@kernel.org.

- Anand
