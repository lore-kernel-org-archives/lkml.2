Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2DBBUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:20:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2DBBUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:20:44 -0400
X-IronPort-AV: E=Sophos;i="4.75,354,1330876800"; 
   d="scan'208";a="4670704"
Message-ID: <4F78FF00.5060804@cn.fujitsu.com>
Date: Mon, 02 Apr 2012 09:21:04 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
CC: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 3/4] block: replace rssd_disk_name_format() to disk_name_format()
References: <4F7581D4.4040301@cn.fujitsu.com> <4F758297.5020600@cn.fujitsu.com> <4F764778.1030406@micron.com>
In-Reply-To: <4F764778.1030406@micron.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 09:20:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 09:20:34,
	Serialize complete at 2012/04/02 09:20:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 03/31/2012 07:54 AM, Asai Thambi Samymuthu Pattrayasamy 
(asamymuthupa) [CONT - Type 2] wrote:
> On 3/30/2012 2:53 AM, Ren Mingxin wrote:
>
>>   Currently, block core has been supplied "disk_name_format()", so
>> we should remove duplicate function "rssd_disk_name_format()"
>> and use the new function to format rssd disk names.
>>
>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> ---
>>   mtip32xx.c |   33 +--------------------------------
>>   1 file changed, 1 insertion(+), 32 deletions(-)
>
> Looks fine.
>
> Should the subject be "mtip32xx: ..." instead of "block: ..."? I
> understand "block:" as relating to block core. I am fairly new here. If
> "block:" can be used for block drivers too, that is fine too.
>
>

Good idea! Will be fixed in the next version.

-- 
Thanks,
Ren

