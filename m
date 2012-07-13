Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380Ab2GMBSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2GMBSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:18:06 -0400
Message-ID: <4FFF77BB.2040605@redhat.com>
Date: Fri, 13 Jul 2012 09:19:55 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <x498vepklqu.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x498vepklqu.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeff,

On 07/13/2012 12:06 AM, Jeff Moyer wrote:
> Asias He <asias@redhat.com> writes:
>
>> Hi folks,
>>
>> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
>> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
>> gives about 5% to 15% performance improvement.
>>
>> Asias He (5):
>>    aio: Export symbols and struct kiocb_batch for in kernel aio usage
>>    eventfd: Export symbol eventfd_file_create()
>>    vhost: Make vhost a separate module
>>    vhost-net: Use VHOST_NET_FEATURES for vhost-net
>>    vhost-blk: Add vhost-blk support
>
> I only saw patches 0 and 1.  Where are the other 4?  If the answer is,
> "not on lkml," then please resend them, CC'ing lkml.

I did send all the 0-5 patches to lkml, but I somehow messed up the 
thread. Will CC you next time.

> I'd like to be able to see the usage of the aio routines.

OK. It'd be nice if you could review. Thanks.

-- 
Asias


