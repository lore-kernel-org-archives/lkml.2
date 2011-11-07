Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1KGMsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:48:13 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:54046 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab1KGMsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:48:09 -0500
Date: Mon, 7 Nov 2011 07:47:57 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Message-ID: <20111107124757.GC24685@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Blue Swirl <blauwirbel@gmail.com>
References: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
 <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
 <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
 <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
 <4EB7B1A9.9000409@redhat.com>
 <alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
 <4EB7CA52.5050409@redhat.com>
 <20111107122902.GA24685@thunk.org>
 <CAOJsxLGuRtWHbOugqHoxCNDmCrtiLFh7xMo8BVGNprG3GoanOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGuRtWHbOugqHoxCNDmCrtiLFh7xMo8BVGNprG3GoanOQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:42:57PM +0200, Pekka Enberg wrote:
> On Mon, Nov 7, 2011 at 2:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > Because it's a stupid, idiotic thing to do.
> 
> The discussion is turning into whether or not linux/tools makes sense
> or not. I wish you guys would have had it before perf was merged to
> the tree.

Perf was IMHO an overreaction caused by the fact that systemtap and
oprofile people packaged and released the sources in a way that kernel
developers didn't like.

I don't think perf should be used as a precendent that now argues that
any new kernel utility should be moved into the kernel sources.  Does
it make sense to move all of mount, fsck, login, etc., into the kernel
sources?  There are far more kernel tools outside of the kernel
sources than inside the kernel sources.

    	       	       	      	       	    - Ted
