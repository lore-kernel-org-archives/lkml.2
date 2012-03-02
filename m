Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2CBCq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 21:46:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:8401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2CBCqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 21:46:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113692363"
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: Alex Shi <alex.shi@intel.com>
To: David Miller <davem@davemloft.net>, Tang Feng <feng.tang@intel.com>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
        ying.huang@intel.com, netdev@vger.kernel.org
In-Reply-To: <20120217.133327.1178765872497293871.davem@davemloft.net>
References: <1329466694.12669.2976.camel@debian>
	 <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120217.133327.1178765872497293871.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 10:45:17 +0800
Message-ID: <1330656317.21053.1411.camel@debian>
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
> 
> And let's start CC:'ing netdev too.

Add CC to tang feng, He is working on this issue. 

