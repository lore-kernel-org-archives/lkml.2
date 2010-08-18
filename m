Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0HRGXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:23:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:55598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab0HRGXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:23:37 -0400
Message-ID: <4C6B7C6F.1020809@kernel.org>
Date: Wed, 18 Aug 2010 08:23:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org> <20100817132646.GA3577@lst.de> <4C6AB79B.2040303@kernel.org> <20100817170857.GA15297@lst.de>
In-Reply-To: <20100817170857.GA15297@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 Aug 2010 06:23:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 07:08 PM, Christoph Hellwig wrote:
> On Tue, Aug 17, 2010 at 06:23:55PM +0200, Tejun Heo wrote:
>> Yeap, agreed.  I couldn't really understand why the the sequence
>> needed to be atomic for ide in the first place so just left it alone.
>> Do you understand why it tried to be atomic?
> 
> I think initial drafs of the barrier specification talked about atomic
> sequences.  Except for that I can't think of any reason.

Hmm... alright, I'll rip it out.

Thanks.

-- 
tejun
