Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2BTBqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:46:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:63459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2BTBqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:46:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127239063"
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: "Alex,Shi" <alex.shi@intel.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
        ying.huang@intel.com, netdev@vger.kernel.org
In-Reply-To: <20120217.133327.1178765872497293871.davem@davemloft.net>
References: <1329466694.12669.2976.camel@debian>
	 <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120217.133327.1178765872497293871.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 09:44:13 +0800
Message-ID: <1329702253.14084.22.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 13:33 -0500, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 17 Feb 2012 10:50:39 +0100
> 
> > Le vendredi 17 février 2012 à 16:18 +0800, Alex,Shi a écrit :
> >> The tcp_stream loop back performance has about 10% drop on the
> >> commitment on our core2 2 sockets server. This commit has 2
> >> parents(7505afe28, 5983fe), but both of them have no regression. So
> >> guess the impact just happened when this 2 parents joint. That beyond
> >> our capability to dig it more.
> >> 
> >> Any ideas? 
> > 
> > Most probably the more accurate truesize determination is responsible of
> > this tcp regression, since some prior assumptions might be wrong.
> > 
> > Want to give more information on the workload ?
> > Is it a 32 or 64 bit kernel ?

It is 64 bit kernel. Currently we only care 64bit. 

Will try to bring more statistic after our lab recovered. 
> 
> And let's start CC:'ing netdev too.


