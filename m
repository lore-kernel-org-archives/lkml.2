Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2C1Cf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab2C1Cf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:35:58 -0400
Message-ID: <4F727909.5050609@redhat.com>
Date: Wed, 28 Mar 2012 10:35:53 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [V5 PATCH] virtio-net: send gratuitous packets when needed
References: <20120316090100.5223.50783.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120327.223112.2032989102915830685.davem@davemloft.net>
In-Reply-To: <20120327.223112.2032989102915830685.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 10:31 AM, David Miller wrote:
> From: Jason Wang<jasowang@redhat.com>
> Date: Fri, 16 Mar 2012 17:01:01 +0800
>
>> >  As hypervior does not have the knowledge of guest network configuration, it's
>> >  better to ask guest to send gratuitous packets when needed.
>> >  
>> >  Guest tests VIRTIO_NET_S_ANNOUNCE bit during config change interrupt and when it
>> >  is set, a workqueue is scheduled to send gratuitous packet through
>> >  NETDEV_NOTIFY_PEERS. This feature is negotiated through bit
>> >  VIRTIO_NET_F_GUEST_ANNOUNCE.
>> >  
>> >  Changes from v4:
>> >  - typos
>> >  - handle workqueue unconditionally
>> >  - move VIRTIO_NET_S_ANNOUNCE to bit 8 to separate rw bits from ro bits
>> >  
>> >  Changes from v3:
>> >  - cancel the workqueue during freeze
>> >  
>> >  Changes from v2:
>> >  - fix the race between unregister_dev() and workqueue
>> >  
>> >  Signed-off-by: Jason Wang<jasowang@redhat.com>
> What's happening with this patch?
Hi David:

I'm working on a new version of this patch as there's some changes in 
virtio-spec, I would post it soon.

Thanks
