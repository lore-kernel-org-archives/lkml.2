Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1AFPwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:52:21 -0500
Received: from gateway.heeltoe.com ([66.134.219.32]:58519 "EHLO
	gateway.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab1AFPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:52:20 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 10:52:19 EST
X-DKIM: Sendmail DKIM Filter v2.5.4 gateway.heeltoe.com 5525BCC067
Message-ID: <4D25E313.4060202@heeltoe.com>
Date: Thu, 06 Jan 2011 10:43:15 -0500
From: Brad Parker <brad@heeltoe.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Anand Gadiyar <gadiyar@ti.com>
CC: Ming Lei <tom.leiming@gmail.com>, Benoit Cousson <b-cousson@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
References: <20101223171859.f6842045.sfr@canb.auug.org.au><4D139517.3010608@ti.com> <AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com> <4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com> (sfid-20110106_100805_509520_6CE1697E)
In-Reply-To: <4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com> (sfid-20110106_100805_509520_6CE1697E)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's probably expected, but I can't get the EHCI USB port  to work
on a beagle board XM (36xx) using the current omap tree.

It this most likely due to these clock issues?

the (very old) angstrom 2.6.32 kernel works fine, as a comparison.

-brad

