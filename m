Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1FJMW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab1FJMWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:22:25 -0400
Message-ID: <4DF20C71.5050705@redhat.com>
Date: Fri, 10 Jun 2011 14:22:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: virtio scsi host draft specification, v3
References: <4DEE2B15.4090809@redhat.com>	<87lixbgax9.fsf@rustcorp.com.au>	<4DF06F4F.8050308@redhat.com>	<87lix9dioo.fsf@rustcorp.com.au> <BANLkTimqrZYnnVq5KTh3s68_o3Lfr9oWeA@mail.gmail.com>
In-Reply-To: <BANLkTimqrZYnnVq5KTh3s68_o3Lfr9oWeA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 02:14 PM, Stefan Hajnoczi wrote:
> Paolo, I'll switch the Linux guest LLD and QEMU virtio-scsi skeleton
> that I have to comply with the spec.  Does this sound good or did you
> want to write these from scratch?

Why should I want to write things from scratch? :)  Just send me again a 
pointer to your git tree, I'll make sure to add it as a remote this time 
(private mail will do).

Thanks,

Paolo
