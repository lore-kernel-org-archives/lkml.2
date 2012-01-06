Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2AFIOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:14:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48176 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2AFIOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:14:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6580"; a="152718122"
X-IronPort-AV: E=Sophos;i="4.71,465,1320652800"; 
   d="scan'208";a="118947852"
Message-ID: <4F06AD59.3050207@qca.qualcomm.com>
Date: Fri, 6 Jan 2012 10:14:17 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH v2 5/6] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump()
 into functions
References: <20120105132523.22281.95999.stgit@x201>	 <20120105132834.22281.78822.stgit@x201> <1325781489.22154.19.camel@joe2Laptop>
In-Reply-To: <1325781489.22154.19.camel@joe2Laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.130.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 01/05/2012 06:38 PM, Joe Perches wrote:
> On Thu, 2012-01-05 at 15:28 +0200, Kalle Valo wrote:
> 
>> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> []
>> +void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
> []
>> +	ath6kl_printk(KERN_DEBUG, "%pV", &vaf);
> [
>> diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
> []
>> +void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...);
> 
> You need to add
> 
> __printf(2, 3)
> 
> to the prototype.
> 
> If it's not there, the printf formats and arguments aren't verified.
> %pV could do the wrong/bad things.

Nice, I'll add that to v3. Thanks again.

Kalle
