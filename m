Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2CUTew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:34:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64381 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2CUTeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:34:50 -0400
Date: Wed, 21 Mar 2012 21:33:54 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Message-ID: <20120321193354.GB3740@mwesterb-mobl.ger.corp.intel.com>
References: <4F683B36.8090101@metasoft.pl>
 <20120321070707.GA25052@mwesterb-mobl.ger.corp.intel.com>
 <4F69878A.4070901@metasoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F69878A.4070901@metasoft.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:47:22AM +0100, Rafal Prylowski wrote:
> On 2012-03-21 08:07, Mika Westerberg wrote:
> > 
> > Which tree this is supposed to apply? I tried both mainline and -next and it
> > doesn't apply cleanly there.
> > 
> 
> I prepared it for git://git.infradead.org/users/vkoul/slave-dma.git tree.
> Also, I checked that it applies cleanly to:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> (I'm assuming this is mainline).

Yes, it applies cleanly. I messed up when applying it. Sorry about that.
