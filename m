Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2INFEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:04:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47698 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab2INFEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:04:31 -0400
X-Sasl-enc: 5nu4vhGWV/pAP0gUPyr6qtAZcYeD7XIht3ndMH9QB7NM 1347599070
Date: Thu, 13 Sep 2012 22:01:46 -0700
From: Greg KH <greg@kroah.com>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4]: add support for Cypress FX2LP
Message-ID: <20120914050146.GA21944@kroah.com>
References: <7120fd46-da21-4203-8293-7dcdb70f02dc@shmail0>
 <cc3ba139-4ad3-4c24-ba89-009f59abbe14@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc3ba139-4ad3-4c24-ba89-009f59abbe14@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:15:47PM +0200, Rene Buergel wrote:
> This Patch adds support for the newer Cypress FX2LP. It also adapts 
> three drivers currently using ezusb to the interface change. (whiteheat 
> and keyspan[_pda])
> 
> Signed-off-by: René Bürgel <rene.buergel@...>
> --

Shouldn't this be 3 '-' characters?

Also, you forgot to put your email address in here :(

Care to resend this, and the two after it?  I took the first one.

thanks,

greg k-h
