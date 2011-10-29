Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab1J2Xwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:52:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39817 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab1J2XtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:14 -0400
Date: Sat, 29 Oct 2011 13:49:50 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <gregkh@suse.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sven Schnelle <svens@stackframe.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/serial: atmel_serial: fix compilation
Message-ID: <20111029114950.GB22592@ponder.secretlab.ca>
References: <1319801631-14654-1-git-send-email-svens@stackframe.org>
 <4EAAA231.1020601@atmel.com>
 <20111028131811.GA25743@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028131811.GA25743@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 03:18:11PM +0200, Greg KH wrote:
> On Fri, Oct 28, 2011 at 02:38:09PM +0200, Nicolas Ferre wrote:
> > On 10/28/2011 01:33 PM, Sven Schnelle :
> > > If CONFIG_OF is disabled, compilation fails with:
> > > 
> > > drivers/tty/serial/atmel_serial.c: In function 'atmel_serial_probe':
> > > drivers/tty/serial/atmel_serial.c:1788: error: implicit declaration of function 'of_alias_get_id'
> > > 
> > > Fix this by adding the proper CONFIG_OF checks.
> > 
> > Yes, but I would like to avoid this and I have made a patch to address
> > this issue. I have sent it to the device tree guys yesterday:
> > "[PATCH] dt: add empty of_alias_get_id() for non-dt builds"
> > 
> > Maybe we can wait a little and see if it reaches Linus' tree on time. If
> > it is not, I will make sure that such a fix make it to mainline.
> 
> I agree, the other dt: patch is the correct way to fix this, not this
> driver-only #ifdef hack.

I've picked up the of_alias_get_id patch now.

g.

