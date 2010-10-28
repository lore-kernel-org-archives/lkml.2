Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab0J1R1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:27:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46413
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933987Ab0J1R1u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:27:50 -0400
Date: Thu, 28 Oct 2010 10:28:13 -0700 (PDT)
Message-Id: <20101028.102813.59675147.davem@davemloft.net>
To: nacc@us.ibm.com
Cc: eric.dumazet@gmail.com, sonnyrao@us.ibm.com, divy@chelsio.com,
        dm@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb3: fix crash due to manipulating queues before
 registration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101028052349.GA21144@us.ibm.com>
References: <1288242390-28574-1-git-send-email-nacc@us.ibm.com>
	<1288243110.2658.126.camel@edumazet-laptop>
	<20101028052349.GA21144@us.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Aravamudan <nacc@us.ibm.com>
Date: Wed, 27 Oct 2010 22:23:49 -0700

> On 28.10.2010 [07:18:30 +0200], Eric Dumazet wrote:
>> Le mercredi 27 octobre 2010 à 22:06 -0700, Nishanth Aravamudan a écrit :
>> > Hi Eric,
>> > 
>> > Something like the following?:
>> > 
>> > Thanks,
>> > Nish
>> 
>> Yes, probably, but I dont have the hardware so cannot test.
> 
> Sorry, should have been clearer. I do have the hardware, tested with the
> patch, it does work. Wanted to make sure that it made sense to the
> maintainers, of course, but:
> 
> Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

Applied, thank you.
