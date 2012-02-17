Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2BQSde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:33:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53510 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2BQSdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:33:33 -0500
Date: Fri, 17 Feb 2012 13:33:27 -0500 (EST)
Message-Id: <20120217.133327.1178765872497293871.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alex.shi@intel.com, linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
        ying.huang@intel.com, netdev@vger.kernel.org
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1329466694.12669.2976.camel@debian>
	<1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 10:33:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 17 Feb 2012 10:50:39 +0100

> Le vendredi 17 février 2012 à 16:18 +0800, Alex,Shi a écrit :
>> The tcp_stream loop back performance has about 10% drop on the
>> commitment on our core2 2 sockets server. This commit has 2
>> parents(7505afe28, 5983fe), but both of them have no regression. So
>> guess the impact just happened when this 2 parents joint. That beyond
>> our capability to dig it more.
>> 
>> Any ideas? 
> 
> Most probably the more accurate truesize determination is responsible of
> this tcp regression, since some prior assumptions might be wrong.
> 
> Want to give more information on the workload ?
> Is it a 32 or 64 bit kernel ?

And let's start CC:'ing netdev too.
