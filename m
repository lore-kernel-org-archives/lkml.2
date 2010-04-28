Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab0D1CFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:05:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab0D1CFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:05:42 -0400
Message-ID: <4BD798B9.3010007@redhat.com>
Date: Wed, 28 Apr 2010 10:08:57 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v4 Patch 3/3] bonding: make bonding support netpoll
References: <20100427075937.4908.18468.sendpatchset@localhost.localdomain>	<20100427080004.4908.27339.sendpatchset@localhost.localdomain> <20100427.152424.236240666.davem@davemloft.net>
In-Reply-To: <20100427.152424.236240666.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Amerigo Wang <amwang@redhat.com>
> Date: Tue, 27 Apr 2010 03:56:09 -0400
> 
>> +		if ((slave->dev->priv_flags & IFF_DISABLE_NETPOLL)
>> +				|| !slave->dev->netdev_ops->ndo_poll_controller)
> 
> "|| on first line please, plus fix second line's indentation as per
> comments given in patch #1 and #2

Thanks, David!
I will fix all of this style problem.

