Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1HRLo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:44:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60456 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab1HRLo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:44:27 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Thu, 18 Aug 2011 17:14:17 +0530
Subject: RE: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Thread-Topic: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Thread-Index: AcxdmXiwujTiLAScSU6P54WglM4LxQAAlsAw
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D3ADE54@dbde03.ent.ti.com>
References: <1313664271-694-1-git-send-email-gadiyar@ti.com>
 <CAP05o4J01FpphHgV5tpkFGNfTBbjhtScKjWZm4iLi3H1V=EKDQ@mail.gmail.com>
 <20110818112454.GS14514@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110818112454.GS14514@legolas.emea.dhcp.ti.com>
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

Balbi, Felipe wrote:
> HI,
> 
> On Thu, Aug 18, 2011 at 04:52:22PM +0530, Munegowda, Keshava wrote:
> > On Thu, Aug 18, 2011 at 4:14 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> > > This code section seems to have been accidentally copy pasted.
> > > It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
> > > register and prevents the TLL mode from working correctly.
> > >
> > > Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> > > Cc: Keshava Munegowda <keshava_mgowda@ti.com>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> 
> Sam, you can apply this one:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> But I think it needs to be resent with Cc: stable@kernel.org

I'm trying to avoid "Cc: stable@kernel.org" since RMK complained about
this on the Linux ARM kernel list. [1]

- Anand

[1] http://marc.info/?l=linux-arm-kernel&m=131107297012093&w=2
