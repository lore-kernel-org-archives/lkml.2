Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2GRIeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:34:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2GRIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:34:10 -0400
Date: Wed, 18 Jul 2012 10:34:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
In-Reply-To: <1342581293.1726.66.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207181031560.8472@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de> 
 <1342418828.1726.37.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
  <1342421587.1726.49.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
  <1342427305.1726.50.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
  <1342431452.1726.54.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161155280.12302@axis700.grange>
  <1342434256.1726.57.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161249260.18978@axis700.grange>
  <1342437179.1726.61.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161445470.18978@axis700.grange>
 <1342581293.1726.66.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:KMr6DoeKCf6Gpz5a2aXFjZaZzaTfMfie+RCNwfMWTVx
 Vljgvpvh4eKsaAOqCB/fNp2IkqyTsUai/0KnaS+++IV5j0eQXA
 SKgtZmCowBPfm3Cj36SML4ijj6BamTaDZY5gIOuHn6xuwCas61
 jotyKKF6CL7dPFZsjLNkzvK6sxK3V0CscSMREJy9bDdG6Yx/Dv
 cwa0JlhyDCX3JZsm0dg2DQjZglE+CnENQuABlPxQxYZMb5eCLy
 yRPVmDc+Mddav2x+14KapBhgiqu0eBY2EXujocFvnIdiUIRVw4
 ODEmstC/5Hnt74F/9nWxT/Ch51aApzw87wH4IGOCZW+ujJQNKp
 f1Re9HhEJkqYTvZiwr7LopfqrIw46B8SRZky+XeN+3l+winJAY
 ckVVyV9LtghTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Wed, 18 Jul 2012, Vinod Koul wrote:

> On Mon, 2012-07-16 at 14:47 +0200, Guennadi Liakhovetski wrote:
> > > > Yes, that's right - these values have to be written to DMAC channel 
> > > > configuration registers, so, we do not have to change anything, those 
> > > > values can remain DMAC parameters and be passed to it directly from 
> > > > platform data.
> > > Can you get that in future fixes.
> > 
> > Sorry, what exactly would you like to have fixed here? Above I just 
> > described how the driver already functions, what changes do you see 
> > necessary? 
> Why should client pass these two values. So the parameters which can be
> calculated should be, and rest should dmacs platform data and not
> clients.

Hm, let me try again:

> > > > those
> > > > values can remain DMAC parameters and be passed to it directly from
> > > > platform data.

i.e., from DMAC's platform data, they are _not_ passed from clients. Am I 
still missing something?

> And after the removal of the slave and adddr fields, you find that you
> no longer need your specific slave structure and that can be elimnated
> completely.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
