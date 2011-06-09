Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1FIHAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:00:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1FIHAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:00:01 -0400
Message-ID: <4DF06F4F.8050308@redhat.com>
Date: Thu, 09 Jun 2011 08:59:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
References: <4DEE2B15.4090809@redhat.com> <87lixbgax9.fsf@rustcorp.com.au>
In-Reply-To: <87lixbgax9.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 01:28 AM, Rusty Russell wrote:
>> >  after some preliminary discussion on the QEMU mailing list, I present a
>> >  draft specification for a virtio-based SCSI host (controller, HBA, you
>> >  name it).
>
> OK, I'm impressed.  This is very well written and it doesn't make any of
> the obvious mistakes wrt. virtio.

Thanks very much, and thanks to those who corrected my early mistakes.

> I assume you have an implementation, as well?

Unfortunately not; "we're working on it", which means I should start in 
July when I come back from vacation.

Do you prefer to wait for one before I make a patch to the LyX source? 
In the meanwhile, can you reserve a subsystem ID for me?

Paolo
