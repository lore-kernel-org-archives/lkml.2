Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0GZMMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:12:19 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:8266 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152Ab0GZMMR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:12:17 -0400
From: Bhavesh Davda <bhavesh@vmware.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jul 2010 05:10:55 -0700
Subject: Re: [PATCH 2.6.35-rc1] net-next: Fix an overflow bug in vmxnet3 Tx
 descriptor
Thread-Topic: [PATCH 2.6.35-rc1] net-next: Fix an overflow bug in vmxnet3 Tx
 descriptor
Thread-Index: Acssu8oElgHcNcgIST2rkwXFvfSVLA==
Message-ID: <FE86E729-1744-4D87-BEDA-68453C7F8B09@vmware.com>
References: <20100725004329.GB6680@bhavesh-lx1.eng.vmware.com>
 <20100725.170611.71132252.davem@davemloft.net>
In-Reply-To: <20100725.170611.71132252.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about that. I'll keep that in mind for future patches. Thanks for fixing up and commiting this patch.

Regards

- Bhavesh

(From my iPhone)


On Jul 25, 2010, at 5:05 PM, "David Miller" <davem@davemloft.net> wrote:

> From: Bhavesh Davda <bhavesh@vmware.com>
> Date: Sat, 24 Jul 2010 17:43:29 -0700
> 
>> ---
> 
> If you put the "---" there are the beginning of your message,
> the whole commit message is discarded by GIT.
> 
> I said you should put "---" at the end of the commit message,
> when you want to add more side commentary that should not appear
> in the commit message but is for people in this thread to read.
> 
> I fixed this up when adding your patch, but I have no idea why
> you did this.  Please don't do it again.
> 
>> Fix an overflow bug in vmxnet3 Tx descriptor
>> 
>> This patch fixes a bug where a 16K buffer on a Tx descriptor was overflowing
>> into the 'gen' bit in the descriptor thereby corrupting the descriptor and
>> stalling the transmit ring.
>> 
>> Signed-off-by: Bhavesh Davda <bhavesh@vmware.com>
>> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
>> Signed-off-by: Matthew Delco <delcoM@vmware.com>
>> Signed-off-by: Ronghua Zhang <ronghua@vmware.com>
> 
> Applied, thanks.
