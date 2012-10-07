Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2JGIdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 04:33:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2JGIdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 04:33:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 09/17] ARM: imx: select ARM_CPU_SUSPEND if necessary
Date: Sun, 7 Oct 2012 08:33:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-10-git-send-email-arnd@arndb.de> <20121007041233.GM20231@S2101-09.ap.freescale.net>
In-Reply-To: <20121007041233.GM20231@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210070833.31597.arnd@arndb.de>
X-Provags-ID: V02:K0:VL3aHY4aNqj38ggaj8Wa6zQW9wr8c6f6ouwjv8E0+Ym
 NoP0/IOFi3lvQGior4DOLF1cUdB3GyV/VF3KlQtecyhVAYzQ1g
 Fr7bk8JLZMAg50HdN2tvnuml7nWBSCE3gMmbJG64iDoPFKywUg
 syAsXfyDzBZ6c4vnKkXvobvTGZgyWijxZb+xTQv4nNFHfnXVHW
 HPJakomcwe2JiR/6Mplcj9efhF3Uu7RK2RVjtrTyKpc8GHWFHT
 hMEMrkphaIyEWjsxVL1l4sc6zk6HYfWrr4eyUUr3X5g/puax6o
 r8FL3/yWe6Wk0DIZ6z630GOkJGOj/wxLO+cZwy8Z6bJnrlhusJ
 mD+hXlAiNypnEhoDZXgs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2012, Shawn Guo wrote:
> Isn't the following the approach we agreed on?
> 
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/183222/focus=1348538
> 

Yes, you are right, my mistake. That patch was already merged, I just
accidentally picked up the older one again when going through my backlog
and forgot to check that it still applies.

Dropping it from late/fixes now.

	Arnd
