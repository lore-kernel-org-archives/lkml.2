Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0DPLSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:18:07 -0400
Received: from mail2.donator.se ([217.16.195.8]:3193 "EHLO mail2.donator.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab0DPLSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:18:05 -0400
X-MDAV-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:18:03 +0200
X-Spam-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:18:01 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: jakob.viketoft@bitsim.com
X-MDRemoteIP: 10.99.195.158
X-Return-Path: jakob.viketoft@bitsim.com
X-Envelope-From: jakob.viketoft@bitsim.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <4BC84766.5060208@bitsim.com>
Date: Fri, 16 Apr 2010 13:17:58 +0200
From: Jakob Viketoft <jakob.viketoft@bitsim.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: daniel@caiaq.de
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
References: <4BC8330E.6000503@bitsim.com> <20100416100126.GI30801@buzzloop.caiaq.de>
In-Reply-To: <20100416100126.GI30801@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Reply-To: jakob.viketoft@bitsim.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> On Fri, Apr 16, 2010 at 11:51:10AM +0200, Jakob Viketoft wrote:
>> The recent addition of (Colibri) PXA3xx specific declarations breaks
>> the building of the Colibri 270 with similar features.
> 
> Hmm, I can't see any problem here. Which error did you get? Which boards
> did you select in your config?

Hmmm, it appears I was slightly too fast on the trigger there. I 
encountered the problem some time ago when migrating fron 2.6.29 to 
2.6.33.1 and a quick look made me think there was a linking problem. I'm 
finishing up this project now and wanted to push any relevant fixes 
upstream. However, the problem I seem to be getting is something 
different though:

   CC      drivers/pcmcia/pxa2xx_colibri.o
In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')' before 
'*' token
make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
make[1]: *** [drivers/pcmcia] Error 2
make: *** [drivers] Error 2

Is this an error on my part somehow?

	/Jakob

