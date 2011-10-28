Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab1J1Sn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:43:56 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42933 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab1J1Snz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:43:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20138.62532.493295.522948@quad.stoffel.home>
Date: Fri, 28 Oct 2011 14:28:20 -0400
From: "John Stoffel" <john@stoffel.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Johannes Weiner <jweiner@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
In-Reply-To: <b86860d2-3aac-4edd-b460-bd95cb1103e6@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<75efb251-7a5e-4aca-91e2-f85627090363@default>
	<20111027215243.GA31644@infradead.org>
	<1319785956.3235.7.camel@lappy>
	<CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
	<552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
	<CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com
 20111028163053.GC1319@redhat.com>
	<b86860d2-3aac-4edd-b460-bd95cb1103e6@default>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dan" == Dan Magenheimer <dan.magenheimer@oracle.com> writes:

Dan> Second, have you read http://lwn.net/Articles/454795/ ?
Dan> If not, please do.  If yes, please explain what you don't
Dan> see as convincing or tangible or documented.  All of this
Dan> exists today as working publicly available code... it's
Dan> not marketing material.

I was vaguely interested, so I went and read the LWN article, and it
didn't really provide any useful information on *why* this is such a
good idea.

Particularly, I didn't see any before/after numbers which compared the
kernel running various loads both with and without these
transcendental memory patches applied.  And of course I'd like to see
numbers when they patches are applied, but there's no TM
(Transcendental Memory) in actual use, so as to quantify the overhead.

Your article would also be helped with a couple of diagrams showing
how this really helps.  Esp in the cases where the system just
endlessly says "no" to all TM requests and the kernel or apps need to
them fall back to the regular paths.

In my case, $WORK is using linux with large memory to run EDA
simulations, so if we swap, performance tanks and we're out of luck.
So for my needs, I don't see how this helps.

For my home system, I run an 8Gb RAM box with a couple of KVM VMs, NFS
file service to two or three clients (not counting the VMs which mount
home dirs from there as well) as well as some light WWW developement
and service.  How would TM benefit me?  I don't use Xen, don't want to
play with it honestly because I'm busy enough as it is, and I just
don't see the hard benefits.

So the onus falls on *you* and the other TM developers to sell this
code and it's benefits (and to acknowledge it's costs) to the rest of
the Kernel developers, esp those who hack on the VM.  If you can't
come up with hard numbers and good examples with good numbers, then
you're out of luck.

Thanks,
John
