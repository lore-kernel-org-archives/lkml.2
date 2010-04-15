Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0DOIsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab0DOIss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:48:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4BC5D19A.8000605@redhat.com>
References: <4BC5D19A.8000605@redhat.com> <20100406133026.GD20577@parisc-linux.org> <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com> <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org> <20100326175827.GD20055@linux-mips.org> <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org> <17213.1271245760@redhat.com> 
To: Avi Kivity <avi@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Ralf Baechle <ralf@linux-mips.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
Date: Thu, 15 Apr 2010 09:48:12 +0100
Message-ID: <3879.1271321292@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> Even if Intel processors behave that way, other processors (real and
> emulated) use those manuals as a specification.  Emulated processors are
> unlikely to touch an undefined register, but real processors may.
> 
> (qemu tcg appears not to touch the output)

Possibly because the AMD64 spec specifies that the destination will be
unchanged if the source was 0.

David
