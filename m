Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0EZVKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:10:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52451 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0EZVKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:10:35 -0400
Message-ID: <4BFD8D52.2080504@zytor.com>
Date: Wed, 26 May 2010 14:06:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Brian Bloniarz <bmb@athenacr.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>	 <1274727116.2954.5.camel@localhost.localdomain>	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>	 <1274834888.4678.66.camel@localhost.localdomain>	 <4BFC8C77.7020802@athenacr.com> <1274886299.1759.8.camel@work-vm>	 <4BFD4629.6040602@athenacr.com> <1274891109.1759.27.camel@work-vm>	 <4BFD6C2B.4070403@athenacr.com>  <4BFD6DAD.1000302@zytor.com> <1274905177.3383.47.camel@localhost.localdomain>
In-Reply-To: <1274905177.3383.47.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 01:19 PM, john stultz wrote:
>>
>> Yes, Prof. Mills in particular (for those who don't know, he's "Mr.
>> NTP") really gets upset about the way Linux does timekeeping.
>> Unfortunately it's not clear to me that he's willing to work with us as
>> opposed to wanting things to work exactly like BSD, and swive the
>> non-NTP users.
> 
> Although I suspect his dislike for Linux is historical, as Roman
> reworked the ntp code to follow the NTPv4 reference implementation back
> in the 2.6.19 timeframe.
> 
> However I'd be more then happy to try to address any specific
> deficiencies with Linux's NTP implementation if someone can better
> express Prof Mills' critiques are.
> 

That's the $10M question... I think it starts with asking the NTP
community for advice.

	-hpa
