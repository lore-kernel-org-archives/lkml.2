Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1KDQma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:42:30 -0400
Received: from thoth.sbs.de ([192.35.17.2]:22114 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab1KDQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:42:29 -0400
Message-ID: <4EB415DF.3050906@siemens.com>
Date: Fri, 04 Nov 2011 17:42:07 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain> <20111104121601.GA15206@infradead.org> <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com> <20111104130225.GA24563@infradead.org> <CAOJsxLG4+-Hmpt-dfa7auEs6H1RgWWwYYs=zzb8uvJg8m10_Nw@mail.gmail.com> <4EB3F9CE.1050407@siemens.com> <20111104161329.GO1512@8bytes.org>
In-Reply-To: <20111104161329.GO1512@8bytes.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-04 17:13, Joerg Roedel wrote:
> On Fri, Nov 04, 2011 at 03:42:22PM +0100, Jan Kiszka wrote:
>> On 2011-11-04 14:32, Pekka Enberg wrote:
>>> I know you don't see the benefits of integrated code base but I as a
>>> developer do.
>>
>> IIRC, this discussion still lacks striking, concrete examples from the
>> KVM tool vs. QEMU development processes.
> 
> How does it matter? KVM tool does not compete with QEMU.

I'm still under the impression that it will start to compete for the
reference implementation of KVM changes. I might see ghosts, but I
surely do not want to see this happen for many reasons.

> The use cases for both programs are different.

Really?

> KVM tool is a helper for kernel
> developers during development

Well, 'make' is a helper for kernel development as well...

> and additionally good example code on how
> to use the KVM kernel interface (because it focuses on KVM only while
> QEMU is much more than a KVM userspace).

[ If this is architecturally good or bad would be worth a separate
discussion. ]

> Therefore it makes sense for KVM tool to be developed in the kernel tree
> while it doesn't make sense for QEMU.

And I disagree regarding KVM tool based on the arguments brought forward
so far.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
