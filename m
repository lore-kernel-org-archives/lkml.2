Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0CXC0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab0CXC0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:26:54 -0400
Message-ID: <4BA97925.2070500@redhat.com>
Date: Wed, 24 Mar 2010 10:29:57 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       Andy Gospodarek <gospo@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and bonding
 devices
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>	<1269297081.3552.19.camel@calx> <x49zl1zxmou.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49zl1zxmou.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Matt Mackall <mpm@selenic.com> writes:
> 
>> On Mon, 2010-03-22 at 04:17 -0400, Amerigo Wang wrote:
>>> This whole patchset is for adding netpoll support to bridge and bonding
>>> devices. I already tested it for bridge, bonding, bridge over bonding,
>>> and bonding over bridge. It looks fine now.
>> Ages ago, Jeff Moyer took a run at this, added him to the cc: on the off
>> chance he still cares.
> 
> I'll take a look at it in a bit.  For now, here is the link to my
> original post on this for Amerigo's reading pleasure:
> 
>   http://lkml.indiana.edu/hypermail/linux/kernel/0507.0/0206.html
> 

Thanks, Jeff! I will take a look at it.

