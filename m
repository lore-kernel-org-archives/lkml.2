Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2IJU3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:29:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab2IJU3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:29:12 -0400
Message-ID: <504E4D89.3020203@jonmasters.org>
Date: Mon, 10 Sep 2012 16:28:57 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-3-git-send-email-catalin.marinas@arm.com> <20120909172046.GB31430@game.jcrosoft.org> <alpine.LFD.2.02.1209091923180.28681@xanadu.home> <20120910055339.GC31430@game.jcrosoft.org>
In-Reply-To: <20120910055339.GC31430@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 01:53 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 19:29 Sun 09 Sep     , Nicolas Pitre wrote:
>> On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>
>>> On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
>>>> +4. Call the kernel image
>>>> +------------------------
>>>> +
>>>> +Requirement: MANDATORY
>>>> +
>>>> +The decompressed kernel image contains a 32-byte header as follows:
>>>> +
>>>> +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
>>>> +  u32 res0	= 0;		/* reserved */
>>>> +  u64 text_offset;		/* Image load offset */
>>>> +  u64 res1	= 0;		/* reserved */
>>>> +  u64 res2	= 0;		/* reserved */
>>> we need to have a magic to known it's a arm64 kernel
>>
>> You have it: it's 0x14000008 at the beginning.
> fragile

Others have commented on the relocatable kernel non-issue. But to this 
part, also bear in mind that Catalin pointed out boot standardization 
work may change how some AArch64 systems ultimately end up booting.

Thanks,

Jon.
