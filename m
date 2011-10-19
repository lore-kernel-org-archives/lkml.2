Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1JSWtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:49:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1JSWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:49:48 -0400
Date: Wed, 19 Oct 2011 18:49:35 -0400 (EDT)
Message-Id: <20111019.184935.1359396091815243878.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        htejun@gmail.com, fubar@us.ibm.com, andy@greyhouse.net
Subject: Re: [PATCH 0/5] Better namespace handling for
 /sys/class/net/bonding_masters
From: David Miller <davem@davemloft.net>
In-Reply-To: <m18voh158i.fsf@fess.ebiederm.org>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
	<20111019.000932.523712028439316177.davem@davemloft.net>
	<m18voh158i.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 15:49:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 19 Oct 2011 06:27:25 -0700

> David Miller <davem@davemloft.net> writes:
> 
>> From: ebiederm@xmission.com (Eric W. Biederman)
>> Date: Thu, 13 Oct 2011 00:47:46 -0700
>>
>>> Greg, Dave I'm don't know whose tree to merge this through as this code
>>> is equally device-core and networking.  I am hoping that we can get this
>>> improvement merged for 3.2.
>>
>> I'm happy to take this series into my net-next tree.
>>
>> Greg?  Any objections?
> 
> on the 13th Greg said:
> 
>> These all look fine to me, and I have no problem with them going through
>> the network tree as that will most likely be the easiest way due to any
>> potential merge issues.
>> 
>> David, feel free to add an:
>> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Awesome, thanks for the reminder, I'll apply these right now.
