Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab2DKBVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2DKBVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:21:50 -0400
Message-ID: <4F84DCA3.3000805@redhat.com>
Date: Wed, 11 Apr 2012 09:21:39 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        James.Bottomley@HansenPartnership.com,
        Ren Mingxin <renmx@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com> <4F84329A.60703@redhat.com> <20120410133406.GA18899@redhat.com> <20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com> <20120410155308.GB20551@redhat.com>
In-Reply-To: <20120410155308.GB20551@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 11:53 PM, Michael S. Tsirkin wrote:
> On Tue, Apr 10, 2012 at 08:49:43AM -0700, Tejun Heo wrote:
>> Hello, guys.
>>
>> On Tue, Apr 10, 2012 at 04:34:06PM +0300, Michael S. Tsirkin wrote:
>>>> Why not use 'base' below?  neither unit nor base change.
>>>
>>> Yes it's a bit strange, it was the same in Tejun's patch.
>>> Tejun, any idea?
>>
>> It was years ago, so I don't recall much.  I think I wanted to use a
>> variable name which signifies its role - I worked out the rather
>> convoluted base number logic on paper first and I probably wanted to
>> keep the distinctions.  I don't think it really matters at this point
>> tho.  Just make sure those functions are marked deprecated so that no
>> one else copies them.
>>
>> Thanks.
>
> I guess I'll keep it same so it's easier to deduplicate
> if someon wants to.

Why not fix it both in sd_format_disk_name() and virtblk_name_format().
Ren, mind to send v2 to drop the duplicate line?

>
>> --
>> tejun
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization


-- 
Asias
