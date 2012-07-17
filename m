Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab2GQP6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:58:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48563 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab2GQP6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:58:08 -0400
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com> <1341830348-15529-4-git-send-email-david.vrabel@citrix.com> <50058319.2030502@citrix.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <50058319.2030502@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/4] x86: add desc_equal() to compare GDT descriptors
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 17 Jul 2012 17:57:40 +0200
To: David Vrabel <david.vrabel@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <a4d36849-1b12-4cb5-a4d2-8be7ee063810@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry we're all travelling at the moment

David Vrabel <david.vrabel@citrix.com> wrote:

>On 09/07/12 11:39, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>> 
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>
>ping?  Can we get an x86 an x86 maintainer for this patch, please?
>
>David
>
>> ---
>>  arch/x86/include/asm/desc.h |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/desc.h
>b/arch/x86/include/asm/desc.h
>> index 8bf1c06..d26f059 100644
>> --- a/arch/x86/include/asm/desc.h
>> +++ b/arch/x86/include/asm/desc.h
>> @@ -85,6 +85,12 @@ static inline int desc_empty(const void *ptr)
>>  	return !(desc[0] | desc[1]);
>>  }
>>  
>> +static inline bool desc_equal(const struct desc_struct *d1,
>> +			      const struct desc_struct *d2)
>> +{
>> +	return d1->a == d2->a && d1->b == d2->b;
>> +}
>> +
>>  #ifdef CONFIG_PARAVIRT
>>  #include <asm/paravirt.h>
>>  #else

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
