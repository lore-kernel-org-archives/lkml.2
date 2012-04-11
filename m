Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab2DKBae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:30:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51577 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab2DKBac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:30:32 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725016"
Message-ID: <4F84DED8.1080800@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:31:04 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
CC: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        James.Bottomley@HansenPartnership.com, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com> <4F84329A.60703@redhat.com> <20120410133406.GA18899@redhat.com> <20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com> <20120410155308.GB20551@redhat.com> <4F84DCA3.3000805@redhat.com>
In-Reply-To: <4F84DCA3.3000805@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:29:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:29:57,
	Serialize complete at 2012/04/11 09:29:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 04/11/2012 09:21 AM, Asias He wrote:
> On 04/10/2012 11:53 PM, Michael S. Tsirkin wrote:
>> On Tue, Apr 10, 2012 at 08:49:43AM -0700, Tejun Heo wrote:
>>> Hello, guys.
>>>
>>> On Tue, Apr 10, 2012 at 04:34:06PM +0300, Michael S. Tsirkin wrote:
>>>>> Why not use 'base' below?  neither unit nor base change.
>>>>
>>>> Yes it's a bit strange, it was the same in Tejun's patch.
>>>> Tejun, any idea?
>>>
>>> It was years ago, so I don't recall much.  I think I wanted to use a
>>> variable name which signifies its role - I worked out the rather
>>> convoluted base number logic on paper first and I probably wanted to
>>> keep the distinctions.  I don't think it really matters at this point
>>> tho.  Just make sure those functions are marked deprecated so that no
>>> one else copies them.
>>>
>>> Thanks.
>>
>> I guess I'll keep it same so it's easier to deduplicate
>> if someon wants to.

So, I'd keep this in the next version.

>
> Why not fix it both in sd_format_disk_name() and virtblk_name_format().
> Ren, mind to send v2 to drop the duplicate line?
>

I'll send v2 soon.

-- 
Thanks,
Ren

