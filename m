Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab2GMBiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab2GMBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:38:16 -0400
Message-ID: <4FFF7C73.2060707@redhat.com>
Date: Fri, 13 Jul 2012 09:40:03 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/5] aio: Export symbols and struct kiocb_batch for in
 kernel aio usage
References: <1342107302-28116-1-git-send-email-asias@redhat.com>  <1342107302-28116-2-git-send-email-asias@redhat.com> <1342115416.3021.60.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342115416.3021.60.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On 07/13/2012 01:50 AM, James Bottomley wrote:
> On Thu, 2012-07-12 at 23:35 +0800, Asias He wrote:
>> This is useful for people who want to use aio in kernel, e.g. vhost-blk.
>>
>> Signed-off-by: Asias He <asias@redhat.com>
>> ---
>>   fs/aio.c            |   37 ++++++++++++++++++-------------------
>>   include/linux/aio.h |   21 +++++++++++++++++++++
>>   2 files changed, 39 insertions(+), 19 deletions(-)
>
> Um, I think you don't quite understand how aio in the kernel would work;
> it's not as simple as just exporting the interfaces.  There's already a
> (very long) patch set from oracle to do this so loop can use aio:
>
> http://marc.info/?l=linux-fsdevel&m=133312234313122

Oh, I did not see this patch set. Thanks for pointing it out! This bit 
hasn't merged, right? I'd love to use the aio_kernel_() interface if it 
is merged. It will simply vhost-blk. Due to lack of better kernel aio 
interface, we are currently doing io_setup, io_submit, etc. in vhost-blk 
on our own.

-- 
Asias


