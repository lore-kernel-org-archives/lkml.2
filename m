Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab2CBM2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 07:28:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64785 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2CBM2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 07:28:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.68.130.72 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330691295.2469.1.camel@edumazet-laptop>
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: David Miller <davem@davemloft.net>, feng.tang@intel.com,
        linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
        ying.huang@intel.com, netdev@vger.kernel.org
Date: Fri, 02 Mar 2012 04:28:15 -0800
In-Reply-To: <1330670277.21053.1448.camel@debian>
References: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120217.133327.1178765872497293871.davem@davemloft.net>
	 <1330656317.21053.1411.camel@debian>
	 <20120301.220743.2174015405223036036.davem@davemloft.net>
	 <1330670277.21053.1448.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 mars 2012 à 14:37 +0800, Alex Shi a écrit :
> On Thu, 2012-03-01 at 22:07 -0500, David Miller wrote:
> > From: Alex Shi <alex.shi@intel.com>
> > Date: Fri, 02 Mar 2012 10:45:17 +0800
> > 
> > > Add CC to tang feng, He is working on this issue. 
> > 
> > Is he?  I'm pretty sure this is due to the TCP receive window growing
> > issue Eric Dumazet, Neal Cardwell and I are discussing in the thread
> > starting at:
> > 
> > http://marc.info/?l=linux-netdev&m=132916352815286&w=2
> 
> That's great! 
> May my language make you confusing. Actually, Feng is doing
> investigation on this issue. Since you fund out the reason, it saved his
> work. :) 
> 

Actually it would be great if you or Feng could post the exact tests
done and numbers so that we can make sure this is the tracked issue.

Thanks


