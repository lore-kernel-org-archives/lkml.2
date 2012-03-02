Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2CBGib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:38:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:12683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab2CBGia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:38:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113736311"
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: Alex Shi <alex.shi@intel.com>
To: David Miller <davem@davemloft.net>
Cc: feng.tang@intel.com, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        tim.c.chen@intel.com, ying.huang@intel.com, netdev@vger.kernel.org
In-Reply-To: <20120301.220743.2174015405223036036.davem@davemloft.net>
References: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120217.133327.1178765872497293871.davem@davemloft.net>
	 <1330656317.21053.1411.camel@debian>
	 <20120301.220743.2174015405223036036.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 14:37:57 +0800
Message-ID: <1330670277.21053.1448.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 22:07 -0500, David Miller wrote:
> From: Alex Shi <alex.shi@intel.com>
> Date: Fri, 02 Mar 2012 10:45:17 +0800
> 
> > Add CC to tang feng, He is working on this issue. 
> 
> Is he?  I'm pretty sure this is due to the TCP receive window growing
> issue Eric Dumazet, Neal Cardwell and I are discussing in the thread
> starting at:
> 
> http://marc.info/?l=linux-netdev&m=132916352815286&w=2

That's great! 
May my language make you confusing. Actually, Feng is doing
investigation on this issue. Since you fund out the reason, it saved his
work. :) 



