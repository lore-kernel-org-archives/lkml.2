Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab1GIFn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:43:28 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43716 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab1GIFn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:43:27 -0400
X-Sasl-enc: VH8DaYeND/zPeHB60QH6QOaBDD6m4V6F+gtL+eiz9vsC 1310190205
Date: Fri, 8 Jul 2011 22:38:18 -0700
From: Greg KH <greg@kroah.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH v2 2/4] Core device subsystem implementation
Message-ID: <20110709053818.GA14519@kroah.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
 <1310115250-3859-3-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310115250-3859-3-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 09:54:08AM +0100, Marc Zyngier wrote:
> There is a small number of devices that the core kernel needs very
> early in the boot process, namely an interrupt controller and a timer,
> long before the device model is up and running.
> 
> The "core device subsystem" offers a class based device/driver
> matching model, doesn't rely on any other subsystem, is very (too?)
> simple, and support getting information both from DT as well as from
> static data provided by the platform. It also gives the opportunity to
> define the probing order by offering a sorting hook at runtime.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Any reason why you didn't use scripts/get_maintainer.pl to at least
figure out who to send something like this to for review?

Please do so in the future, otherwise it will get overlooked...

greg k-h
