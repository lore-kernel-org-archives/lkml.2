Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2IMKzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:55:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:24168 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2IMKzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:55:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,416,1344236400"; 
   d="scan'208";a="221623400"
Date: Thu, 13 Sep 2012 18:55:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Netfilter Development Maili..." <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: Re: xt_nat_init: BUG: unable to handle kernel NULL pointer
 dereference at 00000000000000e0
Message-ID: <20120913105510.GA31666@localhost>
References: <20120913091629.GA28022@localhost>
 <1347528823.13103.1427.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347528823.13103.1427.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wasnt it already solved ?
> 
> http://1984.lsi.us.es/git/nf-next/commit/?id=00545bec9412d130c77f72a08d6c8b6ad21d4a1
> 
> Just have to wait that netfilter fixes are pushed upstream

OK, sorry. I didn't subscribe many mailing lists and rely on the
search results in google and LKML to avoid duplicate reports..

Thanks,
Fengguang
