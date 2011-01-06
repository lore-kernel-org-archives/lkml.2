Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1AFRA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:00:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62881 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1AFRA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:00:56 -0500
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <4D25E313.4060202@heeltoe.com>
Date: Thu, 6 Jan 2011 17:59:21 +0100
Cc: Anand Gadiyar <gadiyar@ti.com>, Ming Lei <tom.leiming@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8B3471BB-CB3F-4CE6-B523-D9C5E87B9CEC@dominion.thruhere.net>
References: <20101223171859.f6842045.sfr@canb.auug.org.au><4D139517.3010608@ti.com> <AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com> <4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com> (sfid-20110106_100805_509520_6CE1697E) <4D25E313.4060202@heeltoe.com>
To: Brad Parker <brad@heeltoe.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 6 jan 2011, om 16:43 heeft Brad Parker het volgende geschreven:

> It's probably expected, but I can't get the EHCI USB port  to work
> on a beagle board XM (36xx) using the current omap tree.
> 
> It this most likely due to these clock issues?

You need this patch: http://thread.gmane.org/gmane.linux.ports.arm.omap/47807/

I'm currently too lazy to split it up like Nishant wants as I don't see the point splitting for the sake of splitting.