Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0CQF5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0CQF52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:57:28 -0400
Message-ID: <4BA07022.1040702@redhat.com>
Date: Wed, 17 Mar 2010 14:01:06 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] netpoll: allow spaces in its parameter
References: <20100317055707.5013.72217.sendpatchset@localhost.localdomain> <20100316.225431.200776775.davem@davemloft.net>
In-Reply-To: <20100316.225431.200776775.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Amerigo Wang <amwang@redhat.com>
> Date: Wed, 17 Mar 2010 01:53:26 -0400
> 
>> It would be nice if we allow spaces in netconsole parameters,
>> otherwise we get weird results if there are spaces in it.
>>
>> After this patch, we will allow things like:
>>  "netconsole= @192.168.0.1/eth0 , 66666@192.168.0.2/".
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: David Miller <davem@davemloft.net>
> 
> That kernel command line looks absolutely awful, not
> better.
> 
> Sorry I'm not applying this.

The problem is that the dst port is 0 when I even use:

"netconsole=@192.168.0.1/eth0, 66666@192.168.0.2/"

This is awful too? I don't think so...
