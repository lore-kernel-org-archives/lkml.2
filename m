Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab2HJAIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 20:08:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44968 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2HJAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A7D419@ORSMSX101.amr.corp.intel.com>
References: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A7D419@ORSMSX101.amr.corp.intel.com>
Date: Fri, 10 Aug 2012 09:08:21 +0900
Message-ID: <CALLJCT24Us8r7pY4LQTnciUcFvx+mfLcwqwci7aBVjE7B8vocQ@mail.gmail.com>
Subject: Re: [PATCH] [trivial] infiniband: Fix typo in infiniband driver
From: Masanari Iida <standby24x7@gmail.com>
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "roland@kernel.org" <roland@kernel.org>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.
I just posted version 2.

Masanari

On Fri, Aug 10, 2012 at 8:51 AM, Hefty, Sean <sean.hefty@intel.com> wrote:
>> diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c
>> b/drivers/infiniband/hw/amso1100/c2_rnic.c
>> index 8c81992..b80867e 100644
>> --- a/drivers/infiniband/hw/amso1100/c2_rnic.c
>> +++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
>> @@ -439,7 +439,7 @@ static int c2_rnic_close(struct c2_dev *c2dev)
>>
>>  /*
>>   * Called by c2_probe to initialize the RNIC. This principally
>> - * involves initalizing the various limits and resouce pools that
>> + * involves initalizing the various limits and resource pools that
>
> while we're here, can we fix initializing too?  thanks
>
