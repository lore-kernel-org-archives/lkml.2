Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0EREV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:21:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36056
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab0EREVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:21:24 -0400
Date: Mon, 17 May 2010 21:21:33 -0700 (PDT)
Message-Id: <20100517.212133.58417630.davem@davemloft.net>
To: greg@kroah.com
Cc: gregkh@suse.de, ebiederm@xmission.com, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com,
       eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] netns support in the kobject layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100518040844.GB19928@kroah.com>
References: <20100517210318.GA6170@suse.de>
	<20100517.164821.189684939.davem@davemloft.net>
	<20100518040844.GB19928@kroah.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Mon, 17 May 2010 21:08:44 -0700

> On Mon, May 17, 2010 at 04:48:21PM -0700, David Miller wrote:
>> Greg, this is complete bullshit.
> 
> "complete bullshit"?  How about just a "little bullshit" :)

Ok, it was a small turd instead of a big one :-)

>> I reviewed them last week, they are fine
>> and have been around forever.
>> 
>> Merge them in now, making them wait until 2.6.36 is completely rediculious.
> 
> Ok, as they are primarily affecting your subsystem, if you don't object,
> I'll queue them up to my tree tomorrow and push them to Linus within
> this merge period.

Thanks.
