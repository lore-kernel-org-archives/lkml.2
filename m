Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1JNAKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:10:00 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:51199 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1JNAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:09:58 -0400
Date: Thu, 13 Oct 2011 18:09:57 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Felipe Balbi <balbi@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, khilman@ti.com, b-cousson@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 5/5 v14] omap: usb: host: Replace usbhs core driver APIs
 by Runtime pm APIs
In-Reply-To: <Pine.LNX.4.44L0.1110131408440.2026-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1110131809290.24155@utopia.booyaka.com>
References: <Pine.LNX.4.44L0.1110131408440.2026-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Alan Stern wrote:

> To keep things simple, this patch should go through the same submission 
> path as the others in the series.  I view it more as an OMAP thing than 
> an EHCI thing anyway.  For the record:
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks, either I and/or Tony will take it from here, after we get 
Samuel's ack.


- Paul
