Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1KXIdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:33:04 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:34024 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab1KXIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:33:02 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAUAzk5tg6zW/2dsb2JhbABEqmqBBoFyAQEEATocIxAIAw44FCUDIYgYArUNEopQBJRJkg0
Date: Thu, 24 Nov 2011 09:29:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marc Vertes <marc.vertes@sigfox.com>, broonie@opensource.wolfsonmicro.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111124082944.GR23376@infomag.iguana.be>
References: <20111122173227.GK6624@sirena.org.uk> <20111122184051.GA30941@pengutronix.de> <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com> <20111123104926.GB4063@pengutronix.de> <20111123121329.GM23376@infomag.iguana.be> <20111123122018.GA12227@opensource.wolfsonmicro.com> <20111123124037.GN23376@infomag.iguana.be> <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com> <20111123214338.GP23376@infomag.iguana.be> <20111123215223.GC32669@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123215223.GC32669@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > > I do not fully understand yet what has to be done with the timer.
> > 
> > Below the example driver that should get included in the Documentation.
> 
> Shouldn't the timer stuff go to the core instead, activated by some flag?

After we introduced support for multiple watchdoig devices.

Kind regards,
Wim.

