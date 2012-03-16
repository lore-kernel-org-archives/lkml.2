Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161486Ab2CPKAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:00:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41442 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab2CPKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:00:15 -0400
Message-ID: <4F630F29.6020101@samsung.com>
Date: Fri, 16 Mar 2012 03:00:09 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the s5p tree
References: <20120316174546.5121be30a86c2937579bd3f5@canb.auug.org.au> <201203160826.36287.arnd@arndb.de>
In-Reply-To: <201203160826.36287.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/12 01:26, Arnd Bergmann wrote:
> On Friday 16 March 2012, Stephen Rothwell wrote:
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/mach-exynos/common.c between commit 1d7233ac478a ("Merge branch
>> 'next/soc-exynos5250-arch-gpio' into for-next") from the s5p tree and
>> commit 853a0231e057 ("Merge branch 'samsung/soc' into next/soc2") from
>> the arm-soc tree.
>>
>> These merge commits both looks suspect, but I fixed it up as best I could
>> (see below).
>
Thank you, Stehpen.

> Right, both the arm-soc and the s5p tree merge the same commits and
> come to different results. Kgene, please have a look and let me know
> which of the three solutions is correct.
>

Yeah, my resolution is missing and both looks OK to me, actually it's 
just different the position of declaration for 'int ret' and I'm not 
sure which one is better even though I fixed with Arnd's resolution.

Arnd, Stephen, thanks :)

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
