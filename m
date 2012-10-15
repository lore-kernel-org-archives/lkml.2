Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2JOXpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:45:15 -0400
Received: from mail.servus.at ([193.170.194.20]:42443 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab2JOXpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:45:13 -0400
Message-ID: <507CA000.5040905@oberhumer.com>
Date: Tue, 16 Oct 2012 01:45:04 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.9) Gecko/20121011 Thunderbird/10.0.9
MIME-Version: 1.0
To: cover.1349621096.git.markus@oberhumer.co
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 0/3] Update LZO compression
References: <507C61B2.9060503@linux.vnet.ibm.com>
In-Reply-To: <507C61B2.9060503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-15 21:19, Seth Jennings wrote:
>> As requested by akpm I am sending my "lzo-update" branch at
>>
>>   git://github.com/markus-oberhumer/linux.git lzo-update
>>
>> to lkml as a patch series created by "git format-patch -M v3.5..lzo-update".
>>
>> You can also browse the branch at
>>
>>   https://github.com/markus-oberhumer/linux/compare/lzo-update
>>
>> and review the three patches at
>>
>>   https://github.com/markus-oberhumer/linux/commit/7c979cebc0f93dc692b734c12665a6824d219c20
>>   https://github.com/markus-oberhumer/linux/commit/10f6781c8591fe5fe4c8c733131915e5ae057826
>>   https://github.com/markus-oberhumer/linux/commit/5f702781f158cb59075cfa97e5c21f52275057f1
> 
> As this relates to my work on zcache, I just tested these patches on PPC64 and
> they cause the LZO crypto module to fail its self-test:
> 
> [    0.521137] alg: comp: Compression test 1 failed for lzo-generic: output len = 62
> 
> I built the exact same kernel for x86_64 and all is fine.  I suspect an endianness
> related bug, but I haven't looked at the code that closely yet.
> 
> Any ideas?  I'd be happy to test any potential fixes.

The crypto LZO test vectors had to be updated - this should land in linux-next
soon (or you can just pull from my branch).

BTW, this cannot have worked on x86_64 (or any other arch), so you probably
tested the wrong kernel.

Cheers,
Markus

> Seth

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
