Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0HQIWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:22:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:50603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0HQIWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:22:11 -0400
Message-ID: <4C6A45E3.7020005@kernel.org>
Date: Tue, 17 Aug 2010 10:18:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, mst@redhat.com
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org> <201008171046.53220.rusty@rustcorp.com.au>
In-Reply-To: <201008171046.53220.rusty@rustcorp.com.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 08:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 03:16 AM, Rusty Russell wrote:
> On Tue, 17 Aug 2010 02:22:00 am Tejun Heo wrote:
>> From: Tejun Heo <tj@kernle.org>
>>
>> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
>> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
>> indicate the support for FUA.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> And also for the lguest-specific patch.

Thanks.  Acked-by's added.

-- 
tejun
