Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2BNTvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:51:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:42514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760494Ab2BNTvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:51:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="109980477"
Message-ID: <4F3ABB66.1040202@linux.intel.com>
Date: Tue, 14 Feb 2012 11:52:06 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Add the snappy-c compressor to lib v2
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>	<1326414530-10789-2-git-send-email-andi@firstfloor.org> <CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
In-Reply-To: <CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (BTW:  If you're ever reworking this patch set, I'd like to make an ad
> hoc request for slightly different names for fs/btrfs/snappy.c and
> lib/snappy.c)

Why?

> When building a x86 kernel, I get the following errors:
>    CC [M]  lib/snappy.o
> lib/snappy.c: In function 'snappy_init_env':
> lib/snappy.c:1268:2: error: implicit declaration of function 'vmalloc'
>    CC [M]  fs/btrfs/free-space-cache.o
> lib/snappy.c:1268:18: warning: assignment makes pointer from integer
> without a cast
> lib/snappy.c: In function 'snappy_free_env':
> lib/snappy.c:1293:2: error: implicit declaration of function 'vfree'
> make[1]: *** [lib/snappy.o] Error 1
> make: *** [lib] Error 2
>
> The error clears with this patch:

Added thanks.

-Andi

