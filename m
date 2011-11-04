Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab1KDNcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:32:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40479 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab1KDNcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111104130225.GA24563@infradead.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<20111104121601.GA15206@infradead.org>
	<CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
	<20111104130225.GA24563@infradead.org>
Date: Fri, 4 Nov 2011 15:32:45 +0200
X-Google-Sender-Auth: 2OXIFAH0j3g00qlahUKK2fO_aDE
Message-ID: <CAOJsxLG4+-Hmpt-dfa7auEs6H1RgWWwYYs=zzb8uvJg8m10_Nw@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 3:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
> That's pretty much a blanko argument for throwing everything into the
> kernel.  What's next, throwing your jvm into the kernel because you like
> some kernel helpers?

Please don't give Ingo any funny ideas! :-)

On Fri, Nov 4, 2011 at 3:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
> We've been through this a few times - there is no reason why a tool
> using the KVM ioctls should be considered close to the kernel - all
> other users get away just fine staying out of tree, and that has
> helped to keep the ABI stable.

It's not just about the KVM ABI - it's VESA BIOS data structures,
E820, serial console registers, virtio drivers, kernel utils, and perf
utils.

I know you don't see the benefits of integrated code base but I as a
developer do.

On Fri, Nov 4, 2011 at 3:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
> This sounds more like you should create a libkernelutil with useful
> data structures we use in the kernel for userspace programs.  I'd love
> to use that for a few projects, btw.

It's certainly a worthwhile project for someone. I'd love to use that too.

                                Pekka
