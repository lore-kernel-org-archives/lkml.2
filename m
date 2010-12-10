Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0LJGXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 01:23:49 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:35672 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab0LJGXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 01:23:48 -0500
Message-ID: <4D01C770.1080301@lougher.demon.co.uk>
Date: Fri, 10 Dec 2010 06:23:44 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 2/2] Squashfs: Add XZ compression configuration option
References: <4D007315.1090704@lougher.demon.co.uk> <AANLkTimUYrb8EMomgmsW+v7ttbkUH0P57SBD5M4_AGmU@mail.gmail.com>
In-Reply-To: <AANLkTimUYrb8EMomgmsW+v7ttbkUH0P57SBD5M4_AGmU@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Thu, Dec 9, 2010 at 07:11, Phillip Lougher
> <phillip@lougher.demon.co.uk> wrote:
>> --- a/fs/squashfs/Kconfig
>> +++ b/fs/squashfs/Kconfig
>> @@ -53,6 +53,22 @@ config SQUASHFS_LZO
>>
>>          If unsure, say N.
>>
>> +config SQUASHFS_XZ
>> +       bool "Include support for XZ compressed file systems"
>> +       depends on SQUASHFS
>> +       default n
> 
> "default n" is the default, no reason to specify it.
> 

Yes, thanks for pointing that out.

It seems there's a lot of "default n"s in the mainline kernel

% find . -name "Kconfig"| xargs grep "default n" | wc
     485    1535   18753

including two in arch/m68k ;-)

Phillip


