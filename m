Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2CWC5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:57:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2CWC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:57:38 -0400
Message-ID: <4F6BE694.1030509@redhat.com>
Date: Fri, 23 Mar 2012 10:57:24 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] [PATCH] virtio-spec: clarify ro/rw bits and updating
 rule of virtio-net status field
References: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400> <87ty1jpm6p.fsf@rustcorp.com.au> <20120320224805.GA4997@redhat.com> <87ty1ializ.fsf@rustcorp.com.au> <20120321063746.GA6773@redhat.com> <87aa399s0x.fsf@rustcorp.com.au>
In-Reply-To: <87aa399s0x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 12:30 PM, Rusty Russell wrote:
> On Wed, 21 Mar 2012 08:37:46 +0200, "Michael S. Tsirkin"<mst@redhat.com>  wrote:
>> Ah. Right, we need to trap for host to clear the bit.
>> OK, so let's make the bit RO, and add
>> VIRTIO_NET_CTRL_ANNOUNCED to acknowledge that we've
>> seen VIRTIO_NET_S_ANNOUNCE using the control VQ?
> Thanks, that's nice.  Guest should send arp packets first, then send
> VIRTIO_NET_CTRL_ANNOUNCED, and ignore the bit being set in the meantime.
>
> Thanks,
> Rusty.
Sure, I would update and re-send the spec updating patch.

Thanks

