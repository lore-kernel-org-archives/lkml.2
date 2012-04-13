Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab2DMIsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:48:24 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47247 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2DMIsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120413084544.GB15297@stefanha-thinkpad.localdomain>
References: <1334287563-8865-1-git-send-email-zwu.kernel@gmail.com>
	<20120413084544.GB15297@stefanha-thinkpad.localdomain>
Date: Fri, 13 Apr 2012 16:48:20 +0800
Message-ID: <CAEH94LixCn+dKKRPeJxsZ169XwUKGNf0cV6PkxLHRm30gRpKfg@mail.gmail.com>
Subject: Re: [PATCH] virtio_ring: remove unused code in virtqueue_notify()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 4:45 PM, Stefan Hajnoczi
<stefanha@linux.vnet.ibm.com> wrote:
> On Fri, Apr 13, 2012 at 11:26:03AM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  drivers/virtio/virtio_ring.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 5aa43c3..c6a54e6 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -343,8 +343,6 @@ EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
>>   */
>>  void virtqueue_notify(struct virtqueue *_vq)
>>  {
>> -     struct vring_virtqueue *vq = to_vvq(_vq);
>> -
>>       /* Prod other side to tell it about changes. */
>>       vq->notify(_vq);
>
> vq->notify() uses 'vq'.  How does this work?
sorry, i missed vq->notify. thanks
>
> Stefan
>



-- 
Regards,

Zhi Yong Wu
