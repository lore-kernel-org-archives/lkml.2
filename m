Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2HPQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:11:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65167 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2HPQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:11:35 -0400
Message-ID: <502D1A30.4010109@gmail.com>
Date: Thu, 16 Aug 2012 18:05:04 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: bhalevy@tonian.com, jack@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/8] vfs: remove lock and unlock functions for super block
References: <502CC499.4030109@gmail.com> <502CE700.3070709@panasas.com>
In-Reply-To: <502CE700.3070709@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/08/2012 14:26, Boaz Harrosh ha scritto:
> On 08/16/2012 12:59 PM, Marco Stornelli wrote:
>
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Remove lock_super and unlock_super from VFS.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>
>
> You can't remove the lock here. After this patch the tree will
> not compile, and will not be bisectable. You must move this patch
> to be last.
>
> Each patch should leave the tree compileable and with out any
> regressions.
>
> Boaz
>

Yep, you're right. I'll resend it in the right order at the end of first 
review.

Thanks,

Marco
