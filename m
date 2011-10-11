Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab1JKHCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:02:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14492 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab1JKHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:02:44 -0400
Message-ID: <4E93EA10.4030405@dsn.lapis-semi.com>
Date: Tue, 11 Oct 2011 16:02:40 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: linux-next: build failure after merge of the gpio tree
References: <20111006144826.a69a5ea59d4ca94f8f7414cf@canb.auug.org.au> <20111011173714.d54bbcee6c0676ddcc37a1f3@canb.auug.org.au>
In-Reply-To: <20111011173714.d54bbcee6c0676ddcc37a1f3@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/11 15:37), Stephen Rothwell wrote:
> Hi Grant,
> 
> On Thu, 6 Oct 2011 14:48:26 +1100 Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>
>> After merging the gpio tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
>> ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
>> ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
>> ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
>>
>> Presumably caused by commits 54be566317b6 ("gpio-ml-ioh: Support
>> interrupt function") and 38eb18a6f92d ("gpio-pch: Support interrupt
>> function").
>>
>> I have used the gpio tree from next-20111005 for today.
> 
> I am still getting this build failure.
> 
I built this driver with success using linux-3.0.
I want to try to build with the same as your build environment.
Where can I get your environment ?

Thanks,
-- 
tomoya
ROHM Co., Ltd.
