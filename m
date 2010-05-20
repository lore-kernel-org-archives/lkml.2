Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0ETSwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:52:12 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:56904 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab0ETSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:52:08 -0400
Date: Thu, 20 May 2010 21:52:50 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-ID: <20100520185249.GB25089@gandalf>
Reply-To: me@felipebalbi.com
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
 <1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
 <20100520110600.be702f58.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520110600.be702f58.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 20, 2010 at 11:06:00AM -0700, Andrew Morton wrote:
> nitlet: I suspect this function is taking gpio_lock sooner than it
> strictly needs to.  Find-tuning that would decrease contention by an
> insignificant amount ;)

heh, I can post another version if you like, but this is pretty much
what other functions are doing, just following the 'standard'.

-- 
balbi
