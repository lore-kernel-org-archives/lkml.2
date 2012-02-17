Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab2BQRBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:01:40 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36032 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab2BQRBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:01:38 -0500
X-Sasl-enc: Wewk0MopRJ/pKqVMIOltzEArV7cD1BFyMGKnIlCrzIdE 1329498097
Date: Fri, 17 Feb 2012 08:59:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-usb@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, tglx@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, avictor.za@gmail.com,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 3/9] ARM/USB: at91/ohci-at91: remove the use of
 irq_to_gpio
Message-ID: <20120217165938.GB25671@kroah.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
 <fab15f7eaf6622e68e62bc3afa533b12f48ca27e.1329139662.git.nicolas.ferre@atmel.com>
 <4F3E20CC.5090205@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3E20CC.5090205@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 10:41:32AM +0100, Nicolas Ferre wrote:
> On 02/13/2012 03:43 PM, Nicolas Ferre :
> > irq_to_gpio() macro will be removed from AT91 GPIO interrupt
> > controller. So we replace it with the use of gpio_to_irq()
> > and a reworked test.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > Cc: linux-usb@vger.kernel.org
> 
> Hi Greg,
> 
> I would like to queue this patch through arm-soc git tree (with all AT91
> material of this patch series).
> 
> So, can I have your "Acked-by" on this one?

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
