Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1GSBnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:43:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45286 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab1GSBnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:43:13 -0400
X-Sasl-enc: sduN48jPOeyaTI4FfkCatfVLA/NrERIBXouXZ+Zw8qfl 1311039791
Date: Mon, 18 Jul 2011 18:18:43 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: JiSheng Zhang <jszhang3@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: xhci: fix OS want to own HC
Message-ID: <20110719011843.GA13807@kroah.com>
References: <20110716110419.726be2b0@ustc>
 <20110718164410.GA4879@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718164410.GA4879@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 09:44:10AM -0700, Sarah Sharp wrote:
> On Sat, Jul 16, 2011 at 11:04:19AM +0800, JiSheng Zhang wrote:
> > Software should set XHCI_HC_OS_OWNED bit to request ownership of xHC
> 
> Good catch!  I'll queue this up to my for-usb-linus branch and send it
> out to Greg later today.
> 
> Greg, do you think it's too late to get this into 3.0?

Yes.

> Shall I just add it to usb-next and mark it for stable?

Yes.

thanks,

greg k-h
