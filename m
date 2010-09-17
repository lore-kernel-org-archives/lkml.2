Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0IQIAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:00:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36410 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab0IQIAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:00:40 -0400
Message-ID: <4C932027.8070501@kernel.dk>
Date: Fri, 17 Sep 2010 10:00:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, Will Drewry <wad@chromium.org>
Subject: Re: linux-next: Tree for September 16 (do_mounts.c)
References: <20100916152805.c9f31656.sfr@canb.auug.org.au>	<20100916091125.f12cc17c.randy.dunlap@oracle.com> <20100917073126.f382c799.sfr@canb.auug.org.au>
In-Reply-To: <20100917073126.f382c799.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 23:31, Stephen Rothwell wrote:
> On Thu, 16 Sep 2010 09:11:25 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> When CONFIG_BLOCK is not enabled:
>>
>> init/do_mounts.c:71: error: implicit declaration of function 'dev_to_part'
>> init/do_mounts.c:71: warning: initialization makes pointer from integer without a cast
>> init/do_mounts.c:73: error: dereferencing pointer to incomplete type
>> init/do_mounts.c:76: error: dereferencing pointer to incomplete type
>> init/do_mounts.c:76: error: dereferencing pointer to incomplete type
>> init/do_mounts.c:102: error: implicit declaration of function 'part_pack_uuid'
>> init/do_mounts.c:104: error: 'block_class' undeclared (first use in this function)
> 
> Caused by commit b5af921ec02333e943efb59aca4f56b78fc0e100 ("init: add
> support for root devices specified by partition UUID") from the block tree.

Thanks for the report Randy, I've merged a fix for this.

-- 
Jens Axboe

