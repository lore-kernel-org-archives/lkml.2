Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0C2WJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:09:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52323
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab0C2WJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:09:23 -0400
Date: Mon, 29 Mar 2010 15:09:24 -0700 (PDT)
Message-Id: <20100329.150924.144366212.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, michael.s.gilbert@gmail.com,
       davem@davemeloft.net, romieu@fr.zoreil.com, eric.dumazet@gmail.com
Subject: Re: [PATCH] r8169: offical fix for CVE-2009-4537 (overlength frame
 DMAs)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269900105.8653.389.camel@localhost>
References: <20100329160356.GC22733@hmsreliant.think-freely.org>
	<1269900105.8653.389.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 29 Mar 2010 23:01:45 +0100

> It also sucks that the secure but low-performance behaviour is enabled
> for all variants, while AIUI only some suffer from the bug.  I realise
> you probably don't have access to every variant (and neither does
> Francois) but perhaps you could come up with a test case that could be
> used to start whitelisting common variants that don't have the bug?

As far as we know all chip variants seem to have the problem.

Furthermore, this issue has been known about and investigated for
about 3 months.  In that time no better options for handling this
issue reliably have been discovered and implemented.

Feel free to code up (and test) something better yourself if you don't
like the fix as it exists currently. :-)

