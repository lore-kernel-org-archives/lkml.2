Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540Ab2BNO0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:26:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41376 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2BNO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:26:11 -0500
Message-ID: <4F3A6ECD.7030504@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 08:25:17 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: fix powerpc linux-next break on zsmalloc
References: <1329144469-8575-1-git-send-email-sjenning@linux.vnet.ibm.com> <4F3A43EC.2030209@gmx.de> <4F3A480C.9090407@gmx.de>
In-Reply-To: <4F3A480C.9090407@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021414-5518-0000-0000-000002383125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 05:39 AM, Marc Dietrich wrote:
> Am 14.02.2012 12:22, schrieb Marc Dietrich:
>> Am 13.02.2012 15:47, schrieb Seth Jennings:
>>> linux/vmalloc.h added to zsmalloc-main.c to resolve implicit
>>> declaration errors.
>>>
>>> X86 dependency added to zsmalloc and dependent drivers zcache and zram.
>>>
>>> This X86 only requirement is not ideal.  Working to find portable
>>> functions for __flush_tlb_one and set_pte.
>>
>> sorry, zcache/zram works fine one ARM here. Why not depend on !POWERPC?
> 
> ups, sorry again, I tested an older version only. flush_tlb_one and 
> set_pte is only used with the new allocator as it seems.

Hey Marc,

I haven't forgotten about you.  I know that zcache (and therefore) zsmalloc
must work on ARM to be viable since there are known ARM users.  When we have
a solution, I'll be contacting you to test it on ARM :)

--
Seth

