Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2AEOJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:09:55 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58387 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2AEOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:09:54 -0500
Date: Thu, 5 Jan 2012 14:09:52 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, broonie@opensource.wolfsonmicro.com,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCHv5 1/4] of: document common interrupt controller details
Message-ID: <20120105140952.GE4641@page>
References: <1325726619-31796-1-git-send-email-jamie@jamieiles.com>
 <1325726619-31796-2-git-send-email-jamie@jamieiles.com>
 <4F05AE79.6050108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F05AE79.6050108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:06:49AM -0600, Rob Herring wrote:
> On 01/04/2012 07:23 PM, Jamie Iles wrote:
> > It's common for interrupt controllers to need to encode interrupt
> > trigger types and the Linux specific types seem common.  Document these
> > in a centralized place so that they don't get reinvented each time a new
> > controller is added.
> > 
> > Suggested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> 
> I can take this if you want. Doesn't really matter as it is all going to
> Grant anyway.

OK, whatever is easiest for you.  I guess it's too late for the GPIO 
driver to go into 3.3(?) but this is probably fine to go in now for 
other drivers to base on...

Jamie
