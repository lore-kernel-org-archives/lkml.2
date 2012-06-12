Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2FLGWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:22:04 -0400
Received: from natasha.panasas.com ([67.152.220.90]:44942 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2FLGWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:22:00 -0400
Message-ID: <4FD6DFFA.2050802@panasas.com>
Date: Tue, 12 Jun 2012 09:21:46 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: LKML <linux-kernel@vger.kernel.org>, <osd-dev@open-osd.org>,
        Benny Halevy <bhalevy@tonian.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] exofs: fix sparse non-ANSI function warning
References: <4FD6836F.1020406@xenotime.net> <4FD6DC7A.9000709@panasas.com>
In-Reply-To: <4FD6DC7A.9000709@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 09:06 AM, Boaz Harrosh wrote:

> On 06/12/2012 02:46 AM, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix sparse non-ANSI function warning:
>>
>> fs/exofs/sys.c:112:28: warning: non-ANSI function declaration of function 'exofs_sysfs_dbg_print'
>>
> 
> 
> Thanks, will push for 3.6 merge window. Might take me
> a few days to push to linux-next
> 


Linus already pushed this for -rc3, cool less work for me ;-)

Thanks guys
Boaz

> Boaz
> 


