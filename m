Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1J1NSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:18:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1J1NSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:18:33 -0400
Date: Fri, 28 Oct 2011 15:18:11 +0200
From: Greg KH <gregkh@suse.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Sven Schnelle <svens@stackframe.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/serial: atmel_serial: fix compilation
Message-ID: <20111028131811.GA25743@suse.de>
References: <1319801631-14654-1-git-send-email-svens@stackframe.org>
 <4EAAA231.1020601@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAAA231.1020601@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 02:38:09PM +0200, Nicolas Ferre wrote:
> On 10/28/2011 01:33 PM, Sven Schnelle :
> > If CONFIG_OF is disabled, compilation fails with:
> > 
> > drivers/tty/serial/atmel_serial.c: In function 'atmel_serial_probe':
> > drivers/tty/serial/atmel_serial.c:1788: error: implicit declaration of function 'of_alias_get_id'
> > 
> > Fix this by adding the proper CONFIG_OF checks.
> 
> Yes, but I would like to avoid this and I have made a patch to address
> this issue. I have sent it to the device tree guys yesterday:
> "[PATCH] dt: add empty of_alias_get_id() for non-dt builds"
> 
> Maybe we can wait a little and see if it reaches Linus' tree on time. If
> it is not, I will make sure that such a fix make it to mainline.

I agree, the other dt: patch is the correct way to fix this, not this
driver-only #ifdef hack.

thanks,

greg k-h
