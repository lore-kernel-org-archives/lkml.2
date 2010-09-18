Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0IRDRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 23:17:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab0IRDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 23:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <4C932027.8070501@kernel.dk>
References: <20100916152805.c9f31656.sfr@canb.auug.org.au>
	<20100916091125.f12cc17c.randy.dunlap@oracle.com>
	<20100917073126.f382c799.sfr@canb.auug.org.au>
	<4C932027.8070501@kernel.dk>
Date: Fri, 17 Sep 2010 22:17:47 -0500
Message-ID: <AANLkTikNpvwuBe9LvDiC3+0=q57N0c=dyf+N=VMv_nYu@mail.gmail.com>
Subject: Re: linux-next: Tree for September 16 (do_mounts.c)
From: Will Drewry <wad@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 3:00 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2010-09-16 23:31, Stephen Rothwell wrote:
>> On Thu, 16 Sep 2010 09:11:25 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>> When CONFIG_BLOCK is not enabled:
>>>
>>> init/do_mounts.c:71: error: implicit declaration of function 'dev_to_part'
>>> init/do_mounts.c:71: warning: initialization makes pointer from integer without a cast
>>> init/do_mounts.c:73: error: dereferencing pointer to incomplete type
>>> init/do_mounts.c:76: error: dereferencing pointer to incomplete type
>>> init/do_mounts.c:76: error: dereferencing pointer to incomplete type
>>> init/do_mounts.c:102: error: implicit declaration of function 'part_pack_uuid'
>>> init/do_mounts.c:104: error: 'block_class' undeclared (first use in this function)
>>
>> Caused by commit b5af921ec02333e943efb59aca4f56b78fc0e100 ("init: add
>> support for root devices specified by partition UUID") from the block tree.
>
> Thanks for the report Randy, I've merged a fix for this.

Thanks and sorry!
will
