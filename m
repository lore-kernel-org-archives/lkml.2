Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0DPLZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:25:54 -0400
Received: from mail2.donator.se ([217.16.195.8]:4006 "EHLO mail2.donator.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab0DPLZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:25:52 -0400
X-MDAV-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:25:51 +0200
X-Spam-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:25:50 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: jakob.viketoft@bitsim.com
X-MDRemoteIP: 10.99.195.158
X-Return-Path: jakob.viketoft@bitsim.com
X-Envelope-From: jakob.viketoft@bitsim.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <4BC8493D.60900@bitsim.com>
Date: Fri, 16 Apr 2010 13:25:49 +0200
From: Jakob Viketoft <jakob.viketoft@bitsim.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: daniel@caiaq.de
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
References: <4BC8330E.6000503@bitsim.com> <20100416100126.GI30801@buzzloop.caiaq.de> <4BC84766.5060208@bitsim.com>
In-Reply-To: <4BC84766.5060208@bitsim.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Reply-To: jakob.viketoft@bitsim.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakob Viketoft wrote:
> Daniel Mack wrote:
<...>
>   CC      drivers/pcmcia/pxa2xx_colibri.o
> In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
> arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')' before 
> '*' token
> make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
> make[1]: *** [drivers/pcmcia] Error 2
> make: *** [drivers] Error 2

Adding a "#include <mach/mfp.h>" seem to cure this problem. If you agree 
I can supply a new patch with the correct solution this time.

	/Jakob

