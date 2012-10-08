Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2JHQfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:35:00 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:47257 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823Ab2JHQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:34:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Cf99Ea+QakPqWQCAMS5mr
Date: Mon, 8 Oct 2012 09:34:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Philippe De Swert <philippedeswert@gmail.com>
Cc: Philippe De Swert <philippe.deswert@jollamobile.com>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/1] musb : remove generic_interrupt and have all
 drivers define the isr on their own. Remove some unneeded
 CONFIG_SOC_OMAP_3430 instances
Message-ID: <20121008163451.GF3874@atomide.com>
References: <1349369952-7036-1-git-send-email-philippe.deswert@jollamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349369952-7036-1-git-send-email-philippe.deswert@jollamobile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Philippe De Swert <philippedeswert@gmail.com> [121004 10:00]:
> This patch is based on the discussion of a previous patch to fix an issue
> where the omap2430 musb driver is not working for N9/N950.
> 
> Moving all the interrupt handling to the devices. Avoids inclusion of generic
> interrupt and breakage due to sometimes misleading CONFIG options. This makes 
> sure usb always works if on of the subdrivers is chosen. Tested on Nokia N9/N950. 
> 
> Partially clean up CONFIG_SOC_OMAP3430 which is not necessary in the cases
> where I removed it. Also helps with the removal work of those options that 
> Tony Lindgren predicted would happen at some point.

Thanks looks OK to me:

Acked-by: Tony Lindgren <tony@atomide.com>
