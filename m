Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1KQGkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:40:13 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:43892 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab1KQGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:40:12 -0500
Date: Thu, 17 Nov 2011 12:10:02 +0530
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] dmaengine/ste_dma40: support pm in dma40
Message-ID: <20111117064001.GA17619@bnru01>
References: <1321425003-12062-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
 <1321441623.1516.168.camel@vkoul-udesk3>
 <20111117050443.GA6256@bnru01>
 <1321507432.1516.176.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321507432.1516.176.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 06:23:52 +0100, Vinod Koul wrote:
> runtime pm manages the device power management. It will call your
> suspend/resume callbacks when your device is idle/active and manages the
> device usage for you.
> Within your device you need to do your own management, which should be
> linked to channel being active. You should not club the two.
> 
> I am not sure if the clock framework can help you on this

Instead of switching on and off eventlines very frequently, I'll
do it in the runtime_suspend() and runtime_resume(), so that it
looks more neat and can get away with these usage counters.
I will re-work and submit a new version of this patch.

~Narayanan
