Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0ELDhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:37:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53895 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0ELDhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:37:50 -0400
Message-ID: <4BEA226D.3080103@zytor.com>
Date: Tue, 11 May 2010 20:37:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [trivial PATCH] arch/x86: Remove unnecessary returns from void
 function()'s
References: <1273624747.20514.316.camel@Joe-Laptop.home>	 <4BE9F94A.9000907@zytor.com>  <1273626052.20514.319.camel@Joe-Laptop.home> <1273629234.20514.333.camel@Joe-Laptop.home>
In-Reply-To: <1273629234.20514.333.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 06:53 PM, Joe Perches wrote:
> 
> Just a stat from arch/x86:
> 
> There may be a little over 2000 void functions in arch/x86/,
> 40 use returns before the trailing brace.
> 
> Call it churn or consistency, <shrug>.
> 

No, please get something straight:

Consistency is not an end in itself.  Readability is, however.

Avoiding churn, however, is *also* an end in itself.  Sometimes churn is
motivated by an increase in readability.  Churn is *not* motivated just
for "consistency" unless it improves readability.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

