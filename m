Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2K1IMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:12:39 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:50736 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2K1IMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:12:38 -0500
Date: Wed, 28 Nov 2012 09:12:37 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 8/7] pppoatm: fix missing wakeup in pppoatm_send()
Message-ID: <20121128081237.GA30488@shrek.podlesie.net>
References: <201211112257.qABMvhP4021769@thirdoffive.cmf.nrl.navy.mil>
 <1354022867.26346.334.camel@shinybook.infradead.org>
 <20121127102333.68ac3234@thirdoffive.cmf.nrl.navy.mil>
 <1354063697.21562.4.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354063697.21562.4.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:48:17AM +0000, David Woodhouse wrote:
> On Tue, 2012-11-27 at 10:23 -0500, chas williams - CONTRACTOR wrote:
> > yes, but dont call it 8/7 since that doesnt make sense.
> 
> It made enough sense when it was a single patch appended to a thread of
> 7 other patches from Krzysztof. But now it's all got a little more
> complex, so I've tried to collect together the latest version of
> everything we've discussed:

There was also discussion about patch 9/7 "pppoatm: wakeup after ATM
unlock only when it's needed".

> 
>  http://git.infradead.org/users/dwmw2/atm.git
>   git://git.infradead.org/users/dwmw2/atm.git
> 
> David Woodhouse (5):
>       atm: Add release_cb() callback to vcc
>       pppoatm: fix missing wakeup in pppoatm_send()
>       br2684: fix module_put() race

for the three patches above:

Acked-by: Krzysztof Mazur <krzysiek@podlesie.net>

Krzysiek
