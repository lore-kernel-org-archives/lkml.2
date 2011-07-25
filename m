Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1GYLlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:41:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48148
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab1GYLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:41:29 -0400
Date: Mon, 25 Jul 2011 07:41:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Olivier Galibert <galibert@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725114106.GA11393@infradead.org>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725103817.GA21683@infradead.org>
 <20110725110809.GO28787@elte.hu>
 <20110725112412.GA1429@infradead.org>
 <20110725113425.GB2012@dspnet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725113425.GB2012@dspnet.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 01:34:25PM +0200, Olivier Galibert wrote:
> You need someone with taste in the loop.  But if you do, "evolved" is
> always better than "designed before you actually know what you need".
> 
> As I'm sure you perfectly know, for the matter.

Neither is actually helpful.  You reall want reference implementation
on both sides of an ABI, _and_ documentation.  And yes, usually you'll
need a few iterations over it.  In theory you can do that in a "tightly
integrated" enviroment as well, but practice shows simply boilds down
to commiting the bloody thing.

I'm also not sure why we even bother to focus with this side-line
discussion.  It's not like the kvm (as in the kernel kvm module)
developers have written the kvm tools.  It's just another userspace for
the kvm userspace (the fifth if I count correctly), and so far the
reference and often only implementation of any new kvm module feature
is for qemu-kvm.  So no matter where kvm tools lives, if you guys one
day actually start doing major kvm core features it will still evolve
discussing them with the main consumer of those interfaces.
