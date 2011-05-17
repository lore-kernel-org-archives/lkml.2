Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1EQLpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1EQLpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:45:06 -0400
Message-ID: <4DD25FA4.7030307@redhat.com>
Date: Tue, 17 May 2011 14:44:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <4DD19C81.8000902@zytor.com> <20110517070527.GD22305@elte.hu> <4DD23CB6.3050503@redhat.com> <20110517092903.GJ22093@elte.hu> <4DD2409F.4030800@redhat.com> <20110517104654.GN22093@elte.hu> <4DD25D29.9040008@redhat.com> <20110517113851.GD13475@elte.hu>
In-Reply-To: <20110517113851.GD13475@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 02:38 PM, Ingo Molnar wrote:
> >
> >  Depends if the guest uses a read-modify-write pattern or not.  We could do it
> >  transparently in kvm.ko, since the real cr4 need not corresponds to the guest
> >  notion (for example, we often set cr0.wp or cr0.ts even though the guest
> >  wants them clear).
>
> Oh, being transparent is a nice touch when it comes to security measures
> (catching attackers who think there's no SMEP and such) - but that would need
> KVM support and a new ioctl to configure it, right?

Yes.

-- 
error compiling committee.c: too many arguments to function

