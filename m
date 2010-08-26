Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0HZIbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:31:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:38737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab0HZIbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:31:51 -0400
Message-ID: <4C76250B.6060800@kernel.org>
Date: Thu, 26 Aug 2010 10:25:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz>
In-Reply-To: <20100825200223.GE2738@quack.suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 08:31:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 10:02 PM, Jan Kara wrote:
> On Wed 25-08-10 17:57:41, Tejun Heo wrote:
>> On 08/25/2010 06:00 PM, Christoph Hellwig wrote:
>>> On Wed, Aug 25, 2010 at 05:58:42PM +0200, Christoph Hellwig wrote:
>>>> On Wed, Aug 25, 2010 at 05:47:43PM +0200, Tejun Heo wrote:
>>>>> From: Christoph Hellwig <hch@infradead.org>
>>>>>
>>>>> ext4 already uses synchronous discards, no need to add I/O barriers.
>>>>
>>>> This needs the patch that Jan sent in reply to my initial version merged
>>>> into it.
>>>
>>> Actually the jbd2 patch needs it merged, but the point still stands.
>>
>> Yeah, wasn't sure about that one.  Has anyone tested it?  I'll be
>> happy to merge it but I have no idea whether it's correct or not and
>> Jan didn't seem to have tested it so...  Jan, shall I merge the patch?
>   I'm quite confident the patch is correct so you can merge it I think but
> tomorrow I'll give it some crash testing together with the rest of your
> patch set in KVM to be sure.

Patch included in the series before jbd2 conversion patch.

Thanks.

-- 
tejun
