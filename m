Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2EFQfD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 12:35:03 -0400
Received: from bitmer.com ([213.157.87.50]:59269 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2EFQfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 12:35:02 -0400
X-Greylist: delayed 2601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 May 2012 12:35:02 EDT
Message-ID: <4FA69DB8.7060000@bitmer.com>
Date: Sun, 06 May 2012 18:50:16 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
CC: Tony Lindgren <tony@atomide.com>, Oleg Matcovschi <oleg.matcovschi@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] omap: dma: Clear status registers on enable/disable irq.
References: <1334954578-10478-1-git-send-email-oleg.matcovschi@ti.com> <20120504165146.GB5613@atomide.com> <1633215.yCrxk1mQVq@acer>
In-Reply-To: <1633215.yCrxk1mQVq@acer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 10:39 PM, Janusz Krzysztofik wrote:
>> This seems like a nice fix to me. As it affects all omaps, I'd like to
>> see some tested-by from Janusz/Jarkko/Peter. Can you guys give it a 
> try
>> with some audio tests?
> 
> OK, I can do, but perhaps not before next Saturday, when I'm back home, 
> able to actually listen to the audio, not only watch the IRQ counters 
> rising up ;-).
> 
Ok from omap3

Tested-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
