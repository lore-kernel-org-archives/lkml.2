Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2C3KKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:10:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42798 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759348Ab2C3KKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:10:41 -0400
X-IronPort-AV: E=Sophos;i="4.75,343,1330876800"; 
   d="scan'208";a="4658240"
Message-ID: <4F7586B1.9040709@cn.fujitsu.com>
Date: Fri, 30 Mar 2012 18:10:57 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] block: move sd_format_disk_name() into block core
 as disk_name_format()
References: <4F7581D4.4040301@cn.fujitsu.com> <1333101375.2833.34.camel@dabdike>
In-Reply-To: <1333101375.2833.34.camel@dabdike>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 18:08:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 18:08:23,
	Serialize complete at 2012-03-30 18:08:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, James:

On 03/30/2012 05:56 PM, James Bottomley wrote:
> On Fri, 2012-03-30 at 17:50 +0800, Ren Mingxin wrote:
>> This patch series renames "sd_format_disk_name()" to
>> "disk_name_format()" and moves it into block core. So
>> that who needs formatting disk name can use it, instead
>> of duplicating these similar help functions.
>>
>> Ren Mingxin (4):
>>     block: add function disk_name_format() into block core
>>     scsi: replace sd_format_disk_name() to disk_name_format()
> These two should be a single patch so it makes it obvious to anyone
> looking through the change sets that the code is merely being moved.

Thank you very much for so quick checking. I'll merge these
two patches into one in the next version.

> Other than that, everything looks fine to me.
>
>

Thanks,
Ren
