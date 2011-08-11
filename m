Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1HKHVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 03:21:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36000 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1HKHVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 03:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <4E428740.3030106@suse.cz>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	<4E428740.3030106@suse.cz>
Date: Thu, 11 Aug 2011 09:21:44 +0200
Message-ID: <CAHR064hY--=A+hQhBY5tMuW=iDzT81hG7k8JWh9oEvHq1cij0w@mail.gmail.com>
Subject: Re: [PATCH] scripts: add extract-vmlinux
From: Corentin Chary <corentin.chary@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/10 Michal Marek <mmarek@suse.cz>:
> On 4.8.2011 15:52, Corentin Chary wrote:
>> This script can be used to extract vmlinux from a compressed
>> kernel image (bzImage, etc..). It's inspired from (a subset of)
>> extract-ikconfig.
>
> Nice.
>
>
>> I don't know if this scripts really have this place in the kernel
>> tree, but it's something a lot of people have been looking for (mainly
>> people with xen < 4 that doesn't support bzImages at all).
>
> I think it makes sense to have it in the tree.
>
>
>> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
>> ---
>>  scripts/extract-vmlinux |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 60 insertions(+), 0 deletions(-)
>>  create mode 100755 scripts/extract-vmlinux
>>
>> diff --git a/scripts/extract-vmlinux b/scripts/extract-vmlinux
>> new file mode 100755
>> index 0000000..444f404
>> --- /dev/null
>> +++ b/scripts/extract-vmlinux
>> @@ -0,0 +1,60 @@
>> +#!/bin/sh
>> +# ----------------------------------------------------------------------
>> +# extract-vmlinux - Extract uncompressed vmlinux from a kernel image
>> +#
>> +# The obscure use of the "tr" filter is to work around older versions of
>> +# "grep" that report the byte offset of the line instead of the pattern.
>> +#
>> +# Inspired from extract-ikconfig
>> +# (c) 2009,2010 Dick Streefland <dick@streefland.net>
>> +#
>> +# (c) 2011      Corentin Chary <corentin.chary@gmail.com>
>> +# Licensed under the terms of the GNU General Public License.
>
> I guess you want to use the version 2 of the GPL?

Since it's heavily based on extract-ikconfig I'm not sure I can change
the license.
CCing previous authors of extract-ikconfig to see if they are ok with that.

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
