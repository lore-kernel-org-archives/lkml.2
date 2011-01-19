Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1ASGhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:37:35 -0500
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:61686
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab1ASGha convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:37:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAAMTNk18q2m+/2dsb2JhbAAM5lSFUASFLIkx
X-IronPort-AV: E=Sophos;i="4.60,342,1291564800"; 
   d="scan'208";a="194133631"
Subject: Re: GPIO: Handling multiple lines at once
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4D35BCA1.1050002@antcom.de>
Date: Wed, 19 Jan 2011 17:28:11 +1100
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A507C485-12D7-4ADE-8337-B0F868D6D512@niasdigital.com>
References: <4D35BCA1.1050002@antcom.de>
To: Roland Stigge <stigge@antcom.de>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/01/2011, at 3:15 AM, Roland Stigge wrote:

> Hi,
> 
> in the standard gpio interface (see Documentation/gpio.txt), we have an
> interface to manipulate single GPIO lines.
> 
> Several drivers are implementing an interface for devices that can
> handle multiple lines at once. E.g. Maxim MAX7301
> (drivers/gpio/max7301.c). There, you can get/set/configure 8 bits at
> once which is really helpful if you are handling 8 bit data as
> bytes/characters via the lines.
> 
> Is there an appropriate interface for this case that I'm somehow missing
> from the docs and the code?

Such code isn't upstream, no.

> 
> Or do I need to create it myself?
> 
> Or is this a use case not considered "GPIO" at all?

It's a use case considered less useful than the single-pin case and much much harder to get right.  Search the archives for examples of previous attempts to add this functionality and their failings, if you feel you can correct them please give it a shot!

	--Ben.

> 
> Please CC me.
> 
> Thanks in advance!
> 
> Roland
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

