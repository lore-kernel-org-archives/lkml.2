Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1KNXqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:46:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24638 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab1KNXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:46:08 -0500
Date: Tue, 15 Nov 2011 00:51:57 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: David Miller <davem@davemloft.net>
cc: rmallon@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, xiaosuo@gmail.com, greearb@candelatech.com,
        loke.chetan@gmail.com, waltje@uWalt.NL.Mugnet.ORG,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Subject: Re: [PATCH] net/packet: remove dead code and unneeded variable from
 prb_setup_retire_blk_timer()
In-Reply-To: <20111114.184325.1962580278359413683.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1111150049500.9919@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net> <4EC0AA31.9040403@gmail.com> <alpine.LNX.2.00.1111150034120.9919@swampdragon.chaosbits.net> <20111114.184325.1962580278359413683.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, David Miller wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Date: Tue, 15 Nov 2011 00:37:33 +0100 (CET)
> 
> > David: You may want to pass on this one. I obviously didn't think it 
> > through properly - sorry :-(
> 
> It's already in my tree and pushed out to kernel.org, what in the
> world do you think "applied" means?
> 
I'm sorry about that. I try to be careful with my patches, but sometimes 
mistakes slip through - I'm only human... I do my best, but I mess up 
sometimes and Ryan raised a good point that I had not considered when I 
prepared the patch - what would you have me do except reply to his mail as 
I did?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

