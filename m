Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2I0NIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:08:43 -0400
Received: from skyrme.org ([193.175.80.135]:42259 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2I0NIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:08:41 -0400
Date: 27 Sep 2012 13:08:37 +0000
Message-ID: <20120927130837.GA22448@curry>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        " Wolfram Sang" <w.sang@pengutronix.de>,
        " Sascha Hauer" <kernel@pengutronix.de>,
        " Andrew Morton" <akpm@linux-foundation.org>,
        " Johannes Weiner" <hannes@cmpxchg.org>,
        " Oskar Schirmer" <oskar@scara.com>
Subject: Re: [PATCH v3] watchdog/imx2+: add support for pretimeout interrupt functionality
References: <1347357652-23601-1-git-send-email-oskar@scara.com> <1348155444-24321-1-git-send-email-oskar@scara.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348155444-24321-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.4.2.3i
Organisation: www.embedded-group.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

unless there is another issue with this patch,
could You give an ack now?

thanks,
  Oskar

On Thu, Sep 20, 2012 at 15:37:24 +0000, Oskar Schirmer wrote:
> This watchdog device provides pretimeout facilities:
> Set some timeout value and get informed about imminent
> watchdog activity thru interrupt.
> 
> Allow user to wait for this asynchronous event thru poll(2),
> and to clear it implicitely upon dog appeasement.
> 
> There is only one precedent in current kernel that implements
> watchdog pretimeout, ipmi_watchdog. It provides pretimeout
> event thru poll, and requires a read(2) call to clear it.
> 
> However, as write(2) does calm the dog and so wind up the
> timer anyway, it is obvious to let poll(2) state writability
> where pretimeout has passed.
[...]
