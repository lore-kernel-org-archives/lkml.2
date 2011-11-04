Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1KDNC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:02:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33999
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230Ab1KDNC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:02:56 -0400
Date: Fri, 4 Nov 2011 09:02:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
Message-ID: <20111104130225.GA24563@infradead.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
 <20111104121601.GA15206@infradead.org>
 <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:35:18PM +0200, Pekka Enberg wrote:
> We are reusing kernel code and headers and I am not interested in
> copying them over. Living in the kernel tree is part of the design,
> whether you like it or not.

That's pretty much a blanko argument for throwing everything into the
kernel.  What's next, throwing your jvm into the kernel because you like
some kernel helpers?

We've been through this a few times - there is no reason why a tool
using the KVM ioctls should be considered close to the kernel - all
other users get away just fine staying out of tree, and that has
helped to keep the ABI stable.

This sounds more like you should create a libkernelutil with useful
data structures we use in the kernel for userspace programs.  I'd love
to use that for a few projects, btw.

