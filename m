Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab2CaBOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 21:14:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab2CaBOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 21:14:08 -0400
X-IronPort-AV: E=Sophos;i="4.75,347,1330876800"; 
   d="scan'208";a="4662933"
Message-ID: <4F765A72.6090006@cn.fujitsu.com>
Date: Sat, 31 Mar 2012 09:14:26 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Asias He <asias.hejun@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com> <CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com>
In-Reply-To: <CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-31 09:11:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-31 09:11:48,
	Serialize complete at 2012-03-31 09:11:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, He:

On 03/30/2012 07:22 PM, Asias He wrote:
> On Fri, Mar 30, 2012 at 5:53 PM, Ren Mingxin<renmx@cn.fujitsu.com>  wrote:
>>   The current virtblk's naming algorithm only supports 263  disks.
>> If there are mass of virtblks(exceeding 263), there will be disks
>> with the same name.
> This fix is pretty nice. However, current virtblk's naming still
> supports up to 18278 disks, no?
> ( index 0  ->  vda, index 18277 ->  vdzzz ).

Sorry, I intended to type 26^3+ (26^2+26)...
It may still be a restriction which should be improved though.

Thanks,
Ren
