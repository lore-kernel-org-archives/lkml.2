Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992488Ab2K3Swt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:52:49 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46600 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161056Ab2K3Swq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:52:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6912"; a="9893908"
X-IronPort-AV: E=McAfee;i="5400,1158,6912"; a="2806502"
Message-ID: <50B9007B.4070508@qti.qualcomm.com>
Date: Fri, 30 Nov 2012 10:52:43 -0800
From: Max Krasnyansky <maxk@qti.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <jslaby@suse.cz>, <netdev@vger.kernel.org>, <jirislaby@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: fix bouncing tun/tap entries
References: <1354295140-6355-1-git-send-email-jslaby@suse.cz> <20121130.122813.1136966656907114890.davem@davemloft.net>
In-Reply-To: <20121130.122813.1136966656907114890.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 09:28 AM, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Fri, 30 Nov 2012 18:05:40 +0100
> 
>> Delivery to the following recipient failed permanently:
>>
>>      vtun@office.satix.net
>>
>> Technical details of permanent failure:
>> DNS Error: Domain name not found
>>
>> Of course:
>> $ host office.satix.net
>> Host office.satix.net not found: 3(NXDOMAIN)
>>
>> ===========
>>
>> And "Change of Email Address Notification":
>> Old Address        New Address           Email Subject
>> ------------------------------------------------------
>> maxk@qualcomm.com  maxk@qti.qualcomm.com "tuntap: multiqueue...
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Applied.
> 

Thanks for fixing that guys.

Max

