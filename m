Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1IYOT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 10:19:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1IYOT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 10:19:28 -0400
Date: Sun, 25 Sep 2011 16:19:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
In-Reply-To: <1315235596.26251.201.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1109251612320.11831@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange> 
 <1314282386.1606.42.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
  <1314283286.1606.52.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
  <1314292850.1606.88.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
  <1314619909.1606.130.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108291419410.31184@axis700.grange>
  <1314622113.1606.134.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108300906590.19151@axis700.grange>
  <1314698257.1606.159.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301321500.19151@axis700.grange>
  <Pine.LNX.4.64.1109051007230.1112@axis700.grange>  <1315227964.26251.68.camel@vkoul-udesk3>
 <1315235596.26251.201.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:RbaFyh5keLczs7mjnDdTvLQcM8Uqpt8UA1D0ApU+LQD
 EZ5/Vf6yi1Um1t9r/M751mI0IhEwKY/XK1jQvjBxNAV3y+xEne
 XNg2XanG+OTzfNVwN3/ZZ+f5X7pjbKfKBi95s4MYsUbeSMlXAz
 /oUpKhuw5XBhXRG09fZAgKc5cgfCzrUBu9wpzaD7PnRxOPLDKo
 CUmKLNyMFpEiFWuVZGVINYMobnFU+ydSvtozYjWp7nw9zlZcHq
 wNCa4sJ+nCsXWDCOiDkBmhZTiVME7SmYAhAt1txiQe4bwEkX03
 tulsMmpvYxydgPE0rxbbAlhBP5u+0TxK3xP7QG53vmqY8L/cL2
 fARCzzulyNIgPoVf21l7pRKf2yzQ6z8gqidPnc76sytIRHOYmI
 LS93R1Gz4VvCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Mon, 5 Sep 2011, Vinod Koul wrote:

[snip]

> This patch fails to apply for me, can you please rebase it to me tree
> and resend, I will apply it later this week

Sorry, it didn't apply, because I apparently forgot to send out this 
patch:

http://marc.info/?l=linux-kernel&m=131695995404173&w=2

which I've also cc'ed to you a couple of minutes ago. With that patch 
applied first, the patch in question

http://marc.info/?l=linux-kernel&m=131386369726846&w=2

still applies cleanly on top of the "next" branch of your slave-dma tree.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
