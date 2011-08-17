Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1HQDHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 23:07:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42348 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQDHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 23:07:13 -0400
Date: Tue, 16 Aug 2011 20:04:53 -0700 (PDT)
Message-Id: <20110816.200453.1648804479684623262.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: boot test failure (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313543952.2981.132.camel@deadeye>
References: <20110817105002.efebf85d08460ad99b14be8e@canb.auug.org.au>
	<20110816.175657.1688139393736610845.davem@davemloft.net>
	<1313543952.2981.132.camel@deadeye>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 20:05:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Wed, 17 Aug 2011 02:19:12 +0100

> If you were to use just "yes", then of course it would.  But since there
> is no explicit default, "yes ''" will deselect them.
> 
> Maybe these guards should have "default y"?

The point is to declutter xconfig and friends, if it defaults to
'y' everything will just always expand.
