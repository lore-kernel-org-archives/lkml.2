Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1KHRhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:37:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab1KHRhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:37:22 -0500
Message-ID: <4EB968AB.9060907@redhat.com>
Date: Tue, 08 Nov 2011 19:36:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <4EB93FA4.8020800@redhat.com> <20111108145257.GA10846@infradead.org> <4EB94340.5040205@redhat.com> <20111108145945.GA17842@infradead.org> <4EB96829.1010709@suse.de>
In-Reply-To: <4EB96829.1010709@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 07:34 PM, Alexander Graf wrote:
>>
>>> It could work with a btrfs snapshot, but not everyone uses that.
>> Or LVM snapshot.  Either way, just reusing the root fs without care
>> is a dumb idea, and I really don't want any tool or script that
>> encurages such braindead behaviour in the kernel tree.
>
>
> Heh, yeah, the intent was obviously to have a separate rootfs tree
> somewhere in a directory. But that's not available at first when
> running this, so I figured for a simple "get me rolling" FAQ directing
> the guest's rootfs to / at least gets you somewhere (especially when
> run as user with init=/bin/bash).
>

Right, init=/bin/bash is not too insane for rootfs passthrough.

/proc will be completely broken though, need to mount the guest's.

-- 
error compiling committee.c: too many arguments to function

