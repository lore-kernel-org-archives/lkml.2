Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2CaDEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 23:04:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59890 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2CaDE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 23:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <4F765A72.6090006@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
 <CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com> <4F765A72.6090006@cn.fujitsu.com>
From: Asias He <asias.hejun@gmail.com>
Date: Sat, 31 Mar 2012 11:03:47 +0800
Message-ID: <CAFO3S41ag8wih8941qmpUGM=JbY_MsF28pNom-SRxW3M67_k3A@mail.gmail.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass of
 disks naming
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 9:14 AM, Ren Mingxin <renmx@cn.fujitsu.com> wrote:
>  Hi, He:
>
>
> On 03/30/2012 07:22 PM, Asias He wrote:
>>
>> On Fri, Mar 30, 2012 at 5:53 PM, Ren Mingxin<renmx@cn.fujitsu.com>  wrote:
>>>
>>>  The current virtblk's naming algorithm only supports 263  disks.
>>> If there are mass of virtblks(exceeding 263), there will be disks
>>> with the same name.
>>
>> This fix is pretty nice. However, current virtblk's naming still
>> supports up to 18278 disks, no?
>> ( index 0  ->  vda, index 18277 ->  vdzzz ).
>
>
> Sorry, I intended to type 26^3+ (26^2+26)...
> It may still be a restriction which should be improved though.

OK.

-- 
Asias He
