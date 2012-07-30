Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2G3G2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:28:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44332 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2G3G2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:28:00 -0400
Message-ID: <5016296A.5070809@redhat.com>
Date: Mon, 30 Jul 2012 08:27:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, mashirle@us.ibm.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        sri@us.ibm.com
Subject: Re: [net-next RFC V5 3/5] virtio: intorduce an API to set affinity
 for a virtqueue
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-4-git-send-email-jasowang@redhat.com> <5012A7D3.4040800@redhat.com> <20120729204030.GB13802@redhat.com>
In-Reply-To: <20120729204030.GB13802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/07/2012 22:40, Michael S. Tsirkin ha scritto:
>> > Did you set the affinity manually in your experiments, or perhaps there
>> > is a difference between scsi and networking... (interrupt mitigation?)
> 
> You need to run irqbalancer in guest to make it actually work. Do you?

Yes, of course, now on to debugging that one.  I just wanted to ask
before the weekend if I was missing something as obvious as that.

Paolo
