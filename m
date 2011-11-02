Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab1KBQqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:46:30 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:59912 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585Ab1KBQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:46:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALVzsU5tgw65/2dsb2JhbABCqWyBBoFyAQEEATocIwULCAMOCi4UJQMhAYgUArU1EogdYQSleg
Date: Wed, 2 Nov 2011 17:43:39 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the watchdog tree
Message-ID: <20111102164339.GA11844@infomag.iguana.be>
References: <20111101163748.26d5f1264b56961e36ff0ced@canb.auug.org.au> <20111101120206.GB10029@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101120206.GB10029@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc, Stephen,

> On Tue, Nov 01, 2011 at 04:37:48PM +1100, Stephen Rothwell wrote:
> 
> > drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_start':
> > drivers/watchdog/wm831x_wdt.c:56:40: error: 'struct watchdog_device' has no member named 'priv'
> > drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_stop':
> 
> Wim, it looks from this error like you've applied the original version of
> this I sent on 20th July against the then current API, not the updated
> version I sent on 25th July (which was resent on 4th October) after you
> revised the API.

Yes indeed. I know I compile tested your second patch, but with all the changing of systems I screwed up and indeed used the first patch :-(.

Anyway, I corrected it.

Thanks,
Wim.

