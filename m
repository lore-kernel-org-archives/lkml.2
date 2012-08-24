Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab2HXTnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:43:51 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:62424 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760037Ab2HXTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:43:49 -0400
X-Greylist: delayed 2189 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2012 15:43:48 EDT
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195uITlygs9eDoUOLmuy6MP
Date: Fri, 24 Aug 2012 12:08:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v3 22/23] serial: omap: move uart_omap_port definition
 to C file
Message-ID: <20120824190839.GS11011@atomide.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <1345717983-18179-23-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345717983-18179-23-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [120823 03:38]:
> nobody needs to access the uart_omap_port structure
> other than omap-serial.c file. Let's move that
> structure definition to the C source file in order
> to prevent anyone from accessing our structure.
> 
> Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>
