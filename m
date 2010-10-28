Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075Ab0J1R2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:28:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46419
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039Ab0J1R2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:28:07 -0400
Date: Thu, 28 Oct 2010 10:28:30 -0700 (PDT)
Message-Id: <20101028.102830.115930449.davem@davemloft.net>
To: divy@chelsio.com
Cc: nacc@us.ibm.com, eric.dumazet@gmail.com, sonnyrao@us.ibm.com,
        dm@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb3: fix crash due to manipulating queues before
 registration
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CC919B1.1040602@chelsio.com>
References: <1288236563.2658.59.camel@edumazet-laptop>
	<1288242390-28574-1-git-send-email-nacc@us.ibm.com>
	<4CC919B1.1040602@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 27 Oct 2010 23:35:29 -0700

> On 10/27/2010 10:06 PM, Nishanth Aravamudan wrote:
>> Hi Eric,
>>
>> Something like the following?:
>>
>> Thanks,
>> Nish
>>
>>
>> Along the same lines as "cxgb4: fix crash due to manipulating queues
>> before registration" (8f6d9f40476895571df039b6f1f5230ec7faebad),
>> before
>> commit "net: allocate tx queues in register_netdevice"
>> netif_tx_stop_all_queues and related functions could be used between
>> device allocation and registration but now only after registration.
>> cxgb4 has such a call before registration and crashes now.  Move it
>> after register_netdev.
>>
>> Signed-off-by: Nishanth Aravamudan<nacc@us.ibm.com>
> 
> Acked-by: Divy Le Ray <divy@chelsio.com>

Applied.
