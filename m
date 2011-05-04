Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1EDS5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:57:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52388
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab1EDS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:57:22 -0400
Date: Wed, 04 May 2011 11:56:49 -0700 (PDT)
Message-Id: <20110504.115649.48491788.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: rdunlap@xenotime.net, lkml@techboom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Divide error in bictcp_cong_avoid ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110504113351.4643a0c9@nehalam>
References: <4DC178D3.6030308@techboom.com>
	<20110504104940.cd0d9e9a.rdunlap@xenotime.net>
	<20110504113351.4643a0c9@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 4 May 2011 11:33:51 -0700

> On Wed, 4 May 2011 10:49:40 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
>> > [28522.642590] Pid: 0, comm: swapper Not tainted 2.6.38.5 #6
                                                      ^^^^^^^^

>> > 
>> >   Supermicro X8DTH-i/6/iF/6F
>> > /
>> >   X8DTH
>> > 
> 
> What kernel version?

It's right there in the dump Stephen, see above.
