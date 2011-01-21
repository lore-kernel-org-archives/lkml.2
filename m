Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1AUBvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:51:01 -0500
Received: from ebb05.tieto.com ([131.207.168.36]:65284 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab1AUBvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:51:00 -0500
X-AuditID: 83cfa824-b7cf4ae000002241-45-4d38e681a0b0
Date: Fri, 21 Jan 2011 09:58:47 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Yang Ruirui R <ruirui.r.yang@tietoenator.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb langwell otg: use notifier chain of struct
 otg_transceiver
Message-ID: <20110121015847.GA29402@darkstar>
References: <20110120070513.GA24956@darkstar>
 <4D3825FF.4030905@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D3825FF.4030905@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 02:09:35PM +0200, Sergei Shtylyov wrote:
> Hello.
> 
> On 20-01-2011 10:05, Yang Ruirui wrote:
> 
> > Use notifier chain in otg_transceiver instead of own notifier chain.
> 
> > This patch depends on another patch which change otg_transceiver
> > notifier chain to atomic one, please see:
> > https://lkml.org/lkml/2011/1/19/72
> 
>     Such comments should generally follow the --- tearline.

Agree, I will resend. Thank you.

> 
> > Signed-off-by: Yang Ruirui<ruirui.r.yang@tieto.com>
> > Reviewed-by: Felipe Balbi<balbi@ti.com>
> > ---
> 
> WBR, Sergei
