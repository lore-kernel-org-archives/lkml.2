Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2DIQwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:52:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42103 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2DIQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:52:31 -0400
Message-ID: <4F8313CB.3020105@gmail.com>
Date: Mon, 09 Apr 2012 09:52:27 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq/irq_domain: Quit ignoring error returns from irq_alloc_desc_from().
References: <1333669933-25267-1-git-send-email-ddaney.cavm@gmail.com> <4F7E64E4.3080509@gmail.com> <4F7F1BDD.4070205@gmail.com> <20120406235607.DCCD53E15E9@localhost>
In-Reply-To: <20120406235607.DCCD53E15E9@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 04:56 PM, Grant Likely wrote:
> On Fri, 06 Apr 2012 09:37:49 -0700, David Daney<ddaney.cavm@gmail.com>  wrote:
>> On 04/05/2012 08:37 PM, Rob Herring wrote:
>>> On 04/05/2012 06:52 PM, David Daney wrote:
>>>> From: David Daney<david.daney@cavium.com>
>>>> @@ -380,14 +381,14 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>>>>    	hint = hwirq % irq_virq_count;
>>>>    	if (hint == 0)
>>>>    		hint++;
>>>> -	virq = irq_alloc_desc_from(hint, 0);
>>>
>>> You are not looking at mainline. hint was removed in later versions, and
>>> the referenced commit ids don't exist.
>>
>> Please look at Linus' tree before making incorrect statements about
>> whether or not code exists on the 'mainline'
>
> Rob is indeed mistaken here, but please let's keep things civil.

Sorry about that.  You are correct that it is not acceptable.

David Daney
