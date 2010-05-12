Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0ELD7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:59:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41660 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0ELD7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:59:15 -0400
Message-ID: <4BEA277A.3000505@zytor.com>
Date: Tue, 11 May 2010 20:58:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [trivial PATCH] arch/x86: Remove unnecessary returns from void
 function()'s
References: <1273624747.20514.316.camel@Joe-Laptop.home>	 <4BE9F94A.9000907@zytor.com>  <1273626052.20514.319.camel@Joe-Laptop.home>	 <1273629234.20514.333.camel@Joe-Laptop.home>  <4BEA226D.3080103@zytor.com> <1273636283.20514.337.camel@Joe-Laptop.home>
In-Reply-To: <1273636283.20514.337.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 08:51 PM, Joe Perches wrote:
> On Tue, 2010-05-11 at 20:37 -0700, H. Peter Anvin wrote:
>> Churn is *not* motivated just
>> for "consistency" unless it improves readability.
> 
> Consistency improves readability.

As a general rule, sure.  For any specific instance it is a big "it
depends".

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

