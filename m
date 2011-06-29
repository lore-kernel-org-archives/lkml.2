Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1F2KgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab1F2KgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:36:15 -0400
Message-ID: <4E0B0007.3050901@redhat.com>
Date: Wed, 29 Jun 2011 12:35:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
References: <4DEE2B15.4090809@redhat.com> <4DF21447.6090005@suse.de> <20110612075140.GB11941@redhat.com> <4E0AE0FE.2090905@redhat.com> <20110629100341.GC22900@infradead.org> <4E0AF925.2050707@redhat.com> <20110629103139.GC16757@redhat.com>
In-Reply-To: <20110629103139.GC16757@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 12:31 PM, Michael S. Tsirkin wrote:
> On Wed, Jun 29, 2011 at 12:06:29PM +0200, Paolo Bonzini wrote:
>> On 06/29/2011 12:03 PM, Christoph Hellwig wrote:
>>>>   I agree here, in fact I misread Hannes's comment as "if a driver
>>>>   uses more than one queue it is responsibility of the driver to
>>>>   ensure strict request ordering".  If you send requests to different
>>>>   queues, you know that those requests are independent.  I don't think
>>>>   anything else is feasible in the virtio framework.
>>>
>>> That doesn't really fit very well with the SAM model.  If we want
>>> to use multiple queues for a single LUN it has to be transparent to
>>> the SCSI command stream.  Then again I don't quite see the use for
>>> that anyway.
>>
>> Agreed, I see a use for multiple queues (MSI-X), but not for
>> multiple queues shared by a single LUN.
>
> Then let's make it explicit in the spec?

What, forbid it or say ordering is not guaranteed?  The latter is 
already explicit with the wording suggested in the thread.

Paolo
