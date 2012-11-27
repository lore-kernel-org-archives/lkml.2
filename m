Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2K0Sjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:39:41 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:38397 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2K0Sjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:39:39 -0500
Date: Tue, 27 Nov 2012 19:39:37 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121127183937.GA1105@shrek.podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
 <1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
 <1354036592.2534.6.camel@shinybook.infradead.org>
 <20121127173906.GA11390@shrek.podlesie.net>
 <1354039349.2534.11.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354039349.2534.11.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 06:02:29PM +0000, David Woodhouse wrote:
> 
> I'm not running with that patch. This bug exists for br2684 even before
> it, and I think also for pppoatm.
> 

Did you use your "atm: br2684: Fix excessive queue bloat" patch?

With that patch for pppoatm the dev->close()/pppoatm_send() race
was much easier to trigger. Maybe with an equivalent patch for br2684
the races are also easier triggerable.

Krzysiek
