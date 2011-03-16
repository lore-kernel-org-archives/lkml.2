Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1CPSbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:31:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24855 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1CPSbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:31:12 -0400
Message-ID: <4D8101E9.70603@oracle.com>
Date: Wed, 16 Mar 2011 11:31:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: frank.peters@comcast.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: 2.6.38 Compile Failure e1000e Module
References: <20110316103318.19bd03e4.frank.peters@comcast.net>	<20110316082105.c911bb1c.randy.dunlap@oracle.com> <20110316.111544.115931576.davem@davemloft.net>
In-Reply-To: <20110316.111544.115931576.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D8101EC.006E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/11 11:15, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, 16 Mar 2011 08:21:05 -0700
> 
>> Hi,
>> Please test this patch:
>>
>>
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> e1000e needs to select CRC32 for CRC support.
>> This patch fixes the build error:
>> ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!
>>
>> Reported-by: Frank Peters <frank.peters@comcast.net>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Randy, I applied Eric Dumazet's copy of this fix only because
> his submission preceded your's in terms of time of submission :-)

Ack.  :)

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
