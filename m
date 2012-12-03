Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2LCIy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:54:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59948 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LCIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:54:55 -0500
Message-ID: <50BC68E5.6070605@zankel.net>
Date: Mon, 03 Dec 2012 00:55:01 -0800
From: czankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Arnd Bergmann <arnd@arndb.de>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Max Filippov <jcmvbkbc@gmail.com>, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/5] xtensa: Use generic asm/mmu.h for nommu
References: <1351765467-29244-1-git-send-email-lars@metafoo.de> <1351765467-29244-5-git-send-email-lars@metafoo.de> <50BC62BD.2060602@zankel.net> <50BC661C.6080002@metafoo.de>
In-Reply-To: <50BC661C.6080002@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/12 12:43 AM, Lars-Peter Clausen wrote:
> On 12/03/2012 09:28 AM, czankel wrote:
>> Thanks Lars, I have added it to the Xtensa for_next tree.
>>
>> -Chris
> Hi,
>
> While the patch works standalone. It would be better if it'd go through the
> same tree as the other patches in this series. Patch 1 removes the unused
> vmlist field from the mm_context_t struct in asm-generic/mmu.h. So without that
> patch this patch basically doubles the size of your mm_context_t.
OK, reverted it. Regarding the Xtensa patch,

Acked-by: Chris Zankel <chris@zankel.net>

Thanks,
-Chris

