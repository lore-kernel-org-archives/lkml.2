Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2CUHrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:47:41 -0400
Received: from metasoft.pl ([195.149.224.191]:49907 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab2CUHrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:47:40 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F69878A.4070901@metasoft.pl>
Date: Wed, 21 Mar 2012 08:47:22 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <20120321070707.GA25052@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20120321070707.GA25052@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-21 08:07, Mika Westerberg wrote:
> 
> Which tree this is supposed to apply? I tried both mainline and -next and it
> doesn't apply cleanly there.
> 

I prepared it for git://git.infradead.org/users/vkoul/slave-dma.git tree.
Also, I checked that it applies cleanly to:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
(I'm assuming this is mainline).
