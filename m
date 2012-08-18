Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2HRHNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 03:13:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34920 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2HRHNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 03:13:23 -0400
Message-ID: <502F3F10.9070307@gmail.com>
Date: Sat, 18 Aug 2012 09:06:56 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        adilger.kernel@dilger.ca, dushistov@mail.ru, bharrosh@panasas.com,
        bhalevy@tonian.com, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, hch@infradead.org,
        osd-dev@open-osd.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ext3: remove lock/unlock super
References: <502CC4BA.3040702@gmail.com> <20120816163904.GA17526@quack.suse.cz> <20120816191909.GC31346@thunk.org> <502DE8E8.5080000@gmail.com> <20120817230820.GB573@thunk.org>
In-Reply-To: <20120817230820.GB573@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2012 01:08, Theodore Ts'o ha scritto:
> On Fri, Aug 17, 2012 at 08:47:04AM +0200, Marco Stornelli wrote:
>> Great. I'll remove the calls for ext3/ext4 when I'll submit the
>> second version of the patch.
>
> FYI, I have the following patch my ext4 tree, so I could do more
> intensive testing.  I'll let folks know if anything goes horribly
> wrong, but I'm pretty sure this should be safe.

Yeah, I'm agree. It should be safe.

>
>         	   	     	      	   	    - Ted
>
>>From 81f74e743344217487792e4190f9478963d1bb21 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Fri, 17 Aug 2012 19:00:34 -0400
> Subject: [PATCH] ext4: drop lock_super()/unlock_super()
>
> We don't need lock_super()/unlock_super() any more, since the places
> where it is used, we are protected by the s_umount r/w semaphore.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Marco Stornelli <marco.stornelli@gmail.com>
> ---

I think the patches will go via Al's tree so if Al is agree I'll submit 
the patches without modify ext4 at this point. Al, let me know if we 
want to proceed in a different way.

Marco
