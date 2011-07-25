Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1GYLee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:34:34 -0400
Received: from dspnet.fr ([188.165.44.67]:34974 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1GYLe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:34:26 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jul 2011 07:34:26 EDT
Date: Mon, 25 Jul 2011 13:34:25 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Graf <agraf@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725113425.GB2012@dspnet.fr>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725103817.GA21683@infradead.org>
 <20110725110809.GO28787@elte.hu>
 <20110725112412.GA1429@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725112412.GA1429@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 07:24:12AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 25, 2011 at 01:08:10PM +0200, Ingo Molnar wrote:
> > Fact is that developing ABIs within an integrated project is 
> > *amazingly* powerful. You should try it one day, instead of 
> > criticizing it :-)
> 
> I've been doing this long before you declare it the rosetta stone.  Some
> of the worst ABIs I know come from that kind of development, e.g. all
> the ioctls we have in xfs, inherited from the "tightly integrated" IRIX
> development cycle.

You need someone with taste in the loop.  But if you do, "evolved" is
always better than "designed before you actually know what you need".

As I'm sure you perfectly know, for the matter.

  OG.

