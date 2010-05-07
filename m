Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0EGDVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab0EGDVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:21:51 -0400
Message-ID: <4BE387E0.1040802@redhat.com>
Date: Fri, 07 May 2010 11:24:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and bonding
 devices
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>	<1273111530.21962.2753.camel@calx> <20100506.004457.71584133.davem@davemloft.net>
In-Reply-To: <20100506.004457.71584133.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/10 15:44, David Miller wrote:
> From: Matt Mackall<mpm@selenic.com>
> Date: Wed, 05 May 2010 21:05:30 -0500
>
>> On Wed, 2010-05-05 at 04:11 -0400, Amerigo Wang wrote:
>>> V5:
>>> Fix coding style problems pointed by David.
>>
>> Aside from my concern about the policy of disabling netpoll on
>> bridges/bonds with only partial netpoll support, I don't have any
>> remaining issues with this. But I'll leave it to other folks to ack the
>> underlying driver bits for this series.
>
> Yes the partial support handling is a thorny issue.
>
> But this patch set makes things better than they were before, because
> support over such devices didn't work at all previously.
>
> So I'll toss these patches into net-next-2.6, thanks everyone!

Thank you, David.

