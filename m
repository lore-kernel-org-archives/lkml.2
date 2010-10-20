Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0JTSpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:45:17 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2661 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab0JTSpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:45:15 -0400
Date: Wed, 20 Oct 2010 15:44:24 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
	<tipc-discussion@lists.sourceforge.net>
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Message-ID: <20101020184424.GQ8781@llucax.com.ar>
References: <20101018234547.GA5703@hmsreliant.think-freely.org>
 <20101019021657.GZ8781@llucax.com.ar>
 <20101019.011649.71113115.davem@davemloft.net>
 <20101019110452.GA14410@hmsreliant.think-freely.org>
 <20101019131936.GB8781@llucax.com.ar>
 <20101019201841.GC14410@hmsreliant.think-freely.org>
 <20101020172018.GN8781@llucax.com.ar>
 <0434463FDA60A94FA978ACA44617682DEE84668199@EUSAACMS0702.eamcs.ericsson.se>
 <20101020182411.GO8781@llucax.com.ar>
 <0434463FDA60A94FA978ACA44617682DEE8466821E@EUSAACMS0702.eamcs.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0434463FDA60A94FA978ACA44617682DEE8466821E@EUSAACMS0702.eamcs.ericsson.se>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Maloy, el 20 de octubre a las 14:37 me escribiste:
> > I think if they really go through the wire, it should be in 
> > NBO, and if tipc_subscr and tipc_event are used only 
> > internally, we can still fix the userspace messages when 
> > sending them through the wire.
> 
> There are plenty of protocols around not using NBO over the wire.
> This is not a must. 

Of course, but is harder to sniff and debug if you haven't a fixed BO,
so, if it's easy to adjust transparently to userspace, I think it could
worth the trouble.

But my main concern is backwards compatibility, everything else is
secondary :)

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
The Muppet show was banned from TV in Saudi Arabia
Because one of its stars was a pig
