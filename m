Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2EUJBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:01:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39921 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2EUJB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:01:28 -0400
Message-ID: <4FBA0460.1070300@linaro.org>
Date: Mon, 21 May 2012 10:01:20 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au> <4FB9F818.4030801@linaro.org> <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
In-Reply-To: <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/12 09:40, Stephen Rothwell wrote:
> Hi Lee,
>
> On Mon, 21 May 2012 09:08:56 +0100 Lee Jones<lee.jones@linaro.org>  wrote:
>>
>> The patch itself has had extensive build and run testing, with DT both
>> enabled and disabled. I'm guessing some other changes may be having and
>> influence here. I'm happy to take a look for you. Can you tell me where
>> I can pull the offending branch from please?
>
> The mfd tree can be found here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git#for-next
>
> Did you try building it for X86_64?  What failed for me was an x86_64
> allmodconfig.

That seems broken to me.

Why would any of the X86_64 systems be building ab8500-core code?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
