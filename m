Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1KDQNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:13:32 -0400
Received: from 8bytes.org ([88.198.83.132]:55495 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab1KDQNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:13:31 -0400
Date: Fri, 4 Nov 2011 17:13:29 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
Message-ID: <20111104161329.GO1512@8bytes.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain> <20111104121601.GA15206@infradead.org> <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com> <20111104130225.GA24563@infradead.org> <CAOJsxLG4+-Hmpt-dfa7auEs6H1RgWWwYYs=zzb8uvJg8m10_Nw@mail.gmail.com> <4EB3F9CE.1050407@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB3F9CE.1050407@siemens.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 03:42:22PM +0100, Jan Kiszka wrote:
> On 2011-11-04 14:32, Pekka Enberg wrote:
> > I know you don't see the benefits of integrated code base but I as a
> > developer do.
> 
> IIRC, this discussion still lacks striking, concrete examples from the
> KVM tool vs. QEMU development processes.

How does it matter? KVM tool does not compete with QEMU. The use
cases for both programs are different. KVM tool is a helper for kernel
developers during development and additionally good example code on how
to use the KVM kernel interface (because it focuses on KVM only while
QEMU is much more than a KVM userspace).
Therefore it makes sense for KVM tool to be developed in the kernel tree
while it doesn't make sense for QEMU.

Regards,

	Joerg

