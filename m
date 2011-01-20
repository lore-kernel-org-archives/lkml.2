Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1ATGsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:48:40 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53382 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269Ab1ATGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:48:39 -0500
Date: Thu, 20 Jan 2011 08:48:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Hao Wu <hao.wu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Alek Du <alek.du@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb langwell otg: use notifier chain of struct
 otg_transceiver
Message-ID: <20110120064829.GG2389@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110120065040.GA24879@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120065040.GA24879@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 20, 2011 at 02:50:40PM +0800, Yang Ruirui wrote:
> Use notifier chain in otg_transceiver instead of own notifier chain.
> 
> This patch depends on another patch which change otg_transceiver
> notifier chain to atomic, please see:
> https://lkml.org/lkml/2011/1/19/72

(just one point, try to break commit logs at 72 characters next time,
not sure if Greg will ask you to resend, if he does, you can add the
Reviewed-by line below)

> Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>

I have checked that nobody actually uses
intel_mid_otg_register_notifier() thus:

Reviewed-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
