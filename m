Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1HXTST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:18:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab1HXTSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:18:17 -0400
Message-ID: <4E554E5A.8050902@redhat.com>
Date: Wed, 24 Aug 2011 22:17:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Blue Swirl <blauwirbel@gmail.com>
CC: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around Qemu to test
 kernels
References: <1314137806-5747-1-git-send-email-agraf@suse.de> <CAAu8pHucQ1RMiuZZEXhAnECX__SJZyutO26azwO4QYU4RZ7ZRA@mail.gmail.com>
In-Reply-To: <CAAu8pHucQ1RMiuZZEXhAnECX__SJZyutO26azwO4QYU4RZ7ZRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 08:40 PM, Blue Swirl wrote:
> >  +
> >  +       # Qemu's own build system calls it qemu-system-x86_64
> >  +       [ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-system-x86_64 2>/dev/null)
>
> If you run qemu-system-x86_64 on an i386 host, will it use kvm at all?

I think it will, and that's actually a bug, since kvm doesn't support 
virtualizing long mode on a 32-bit host.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

