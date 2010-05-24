Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0EXUYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:24:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53194 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0EXUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:24:48 -0400
Message-ID: <4BFADF9D.9050209@zytor.com>
Date: Mon, 24 May 2010 13:20:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Brian Bloniarz <bmb@athenacr.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain>
In-Reply-To: <1274727116.2954.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 11:51 AM, john stultz wrote:
> 
> Hmmm. That could be an option for newer cpus that I wouldn't oppose.
> 
> While Peter is correct that the stamped value is probably not very
> accurate, atleast it would be constant from boot to boot, and NTP's
> calculated drift value would be correct. 
> 
> We'd need a check to make sure its not way off, since NTP will give up
> if its outside 500ppm.  So as long as its close to the calibrated value,
> we probably could use it.
> 

Is that still the case?  I thought newer versions of NTP could deal with
large values.  Inaccuracies of way more than 500 ppm are everyday.

	-hpa
