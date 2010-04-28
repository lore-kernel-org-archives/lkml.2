Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0D1NWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:22:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0D1NWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:22:39 -0400
Message-ID: <4BD806E7.7010806@redhat.com>
Date: Wed, 28 Apr 2010 17:59:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       Andy Gospodarek <gospo@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [v4 Patch 1/3] netpoll: add generic support for bridge and 	bonding
 devices
References: <20100427075937.4908.18468.sendpatchset@localhost.localdomain> <j2mce2c83091004272102ye46e65fbod138e63dc58bccd5@mail.gmail.com>
In-Reply-To: <j2mce2c83091004272102ye46e65fbod138e63dc58bccd5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongdong Deng wrote:
> 
> 
> +             if (ops->ndo_netpoll_cleanup)
> +                                       ops->ndo_netpoll_cleanup(np->dev);
> +             np->dev->npinfo = NULL;
> 
> I think it is good to set np->dev->npinfo to NULL  even though we have
> the netpoll_cleanup opt.
> 

This is redundant, since ->ndo_netpoll_cleanup will set it.

Thanks.
