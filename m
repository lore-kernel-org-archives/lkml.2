Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1G1P1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:27:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54184 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab1G1P1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:27:32 -0400
X-Sasl-enc: 1xvEZxfRHsjrP+7Gljurr4z0VIIvgkh72Ux+SUhp4Q7j 1311866851
Date: Thu, 28 Jul 2011 08:17:20 -0700
From: Greg KH <greg@kroah.com>
To: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] USB: option driver: add PID for Vodafone-Huawei K3770
Message-ID: <20110728151720.GA22202@kroah.com>
References: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk>
 <4E3140D2.90608@ru.mvista.com>
 <201107281210.06455.ajb@spheresystems.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107281210.06455.ajb@spheresystems.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 12:10:05PM +0100, Andrew Bird (Sphere Systems) wrote:
> Hi Sergei,
> 
> On Thursday 28 July 2011, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 27-07-2011 20:03, Andrew Bird wrote:
> > > This patch adds the product ID of Huawei's Vodafone K3770 mobile
> > > broadband modem to option.c. This is necessary so that the driver gets
> > > loaded on demand without the intervention of usb_modeswitch. This has
> > > the benefit of it becoming available faster and also ensures that the
> > > option driver is not bound to a network interface that should be claimed
> > > by cdc_ether.
> > 
> >     You seem to be adding 4 product IDs with the identical patch
> > descriptions. Why not do it in a single patch?
> > 
> > > Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
> > 
> > WBR, Sergei
> 
> 	I'm pretty new to this, but I was following the one patch per change 
> idea, so as there are four devices I did a patch for each.
> 
> Happy to squash into one if that's more acceptable to people?

As you did it is fine, I'll queue it up next week when I return from
vacation.

greg k-h
