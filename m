Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1CYNnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:43:05 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:58120 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429Ab1CYNnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:43:02 -0400
Date: Fri, 25 Mar 2011 15:42:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5 v6] usb: Add usb_endpoint_descriptor to be part of
 the struct usb_ep
Message-ID: <20110325134248.GN2609@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1300867420-20864-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300867420-20864-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:03:38AM +0200, Tatyana Brokhman wrote:
> Change usb_ep_enable() prototype to use endpoint descriptor from usb_ep.
> This optimization spares the FDs from saving the endpoint chosen
> descriptor. This optimization is not full though. To fully exploit this
> change one needs to update all the UDCs as well since in the current
> implementation each of them saves the endpoint descriptor in it's
> internal (and extended) endpoint structure.

I'm not sure this is such a good patch. But I don't have strong
arguments against it either.

> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

missing tear line

-- 
balbi
