Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2I0VYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:24:47 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:49590 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754082Ab2I0VYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:24:45 -0400
Date: Thu, 27 Sep 2012 23:24:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Oskar Schirmer <oskar@scara.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] watchdog/imx2+: add support for pretimeout interrupt functionality
Message-ID: <20120927212444.GK16482@spo001.leaseweb.com>
References: <1347357652-23601-1-git-send-email-oskar@scara.com> <1348155444-24321-1-git-send-email-oskar@scara.com> <20120927130837.GA22448@curry>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927130837.GA22448@curry>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

> unless there is another issue with this patch,
> could You give an ack now?
> 
> thanks,
>   Oskar
> 
> On Thu, Sep 20, 2012 at 15:37:24 +0000, Oskar Schirmer wrote:
> > This watchdog device provides pretimeout facilities:
> > Set some timeout value and get informed about imminent
> > watchdog activity thru interrupt.
> > 
> > Allow user to wait for this asynchronous event thru poll(2),
> > and to clear it implicitely upon dog appeasement.
> > 
> > There is only one precedent in current kernel that implements
> > watchdog pretimeout, ipmi_watchdog. It provides pretimeout
> > event thru poll, and requires a read(2) call to clear it.
> > 
> > However, as write(2) does calm the dog and so wind up the
> > timer anyway, it is obvious to let poll(2) state writability
> > where pretimeout has passed.
> [...]

No, I'm not givinbg this an ACK nor a NAK at this moment.
I will review best options after the next merge window.

Kind regards,
Wim.

