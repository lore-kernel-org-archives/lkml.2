Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab1EZSRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:17:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54222 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365Ab1EZSR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qd0fnDdpUROqoPJszqsRx7IYdxLuM6eGGE7j7/7vrIH46DhTGQ9OEkd0nxFOOcdULv
         KjiwxOHekHQNDf0zXh9vAjs6+rezxw4Pi68EnwOdRMQ121GcW1WKIC9J8Bd1YaGTX0BM
         1NlVNmIj2jmVNwFirXme7zX1mFqnQJHNqaZ1c=
Date: Thu, 26 May 2011 21:15:24 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20110526181524.GD2957@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <1306310403.30236.94.camel@vkoul-udesk3>
 <20110525190055.GB2996@acer>
 <1306384690.30236.202.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306384690.30236.202.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:08:10AM +0530, Koul, Vinod wrote:
> On Thu, 2011-05-26 at 00:30 +0530, Mika Westerberg wrote:
> > On Wed, May 25, 2011 at 01:30:03PM +0530, Koul, Vinod wrote:
> > > 
> > > Which tree are these patches going thru?
> > 
> > I was hoping that the dmaengine driver itself would go via dmaengine tree (is
> > it you or Dan who maintain it?) and rest of the patches probably through their
> > respective trees. However, since there are dependencies between the patches,
> > I'm not entirely sure how to proceed with these. Any ideas appreciated :)
> Okay, I can take the DMA one only. 
> It stoo late for .40, I can take it for .41 or whatever that turns out to be 

Great, thanks.

I'll send updated version of the patches soon where I have gathered all the acks
and updated Ryan's email address.
