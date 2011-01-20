Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1ATGzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:55:16 -0500
Received: from ebb05.tieto.com ([131.207.168.36]:51754 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab1ATGzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:55:14 -0500
X-AuditID: 83cfa824-b7b13ae000000ee5-aa-4d37dc517124
Date: Thu, 20 Jan 2011 15:03:01 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: Felipe Balbi <balbi@ti.com>
CC: Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb langwell otg: use notifier chain of struct
 otg_transceiver
Message-ID: <20110120070301.GA24923@darkstar>
References: <20110120065040.GA24879@darkstar>
 <20110120064829.GG2389@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110120064829.GG2389@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 08:48:29AM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Jan 20, 2011 at 02:50:40PM +0800, Yang Ruirui wrote:
> > Use notifier chain in otg_transceiver instead of own notifier chain.
> > 
> > This patch depends on another patch which change otg_transceiver
> > notifier chain to atomic, please see:
> > https://lkml.org/lkml/2011/1/19/72
> 
> (just one point, try to break commit logs at 72 characters next time,
> not sure if Greg will ask you to resend, if he does, you can add the
> Reviewed-by line below)

Thank you for pointing out this. I will resend before he ask:)

> 
> > Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
> 
> I have checked that nobody actually uses
> intel_mid_otg_register_notifier() thus:
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> -- 
> balbi
