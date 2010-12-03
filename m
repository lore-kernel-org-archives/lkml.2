Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab0LCDJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 22:09:50 -0500
Received: from wdscspam3.wdc.com ([129.253.55.42]:52031 "EHLO
	wdscspam3.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab0LCDJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 22:09:49 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2010 22:09:49 EST
X-IronPort-AV: E=Sophos;i="4.59,291,1288594800"; 
   d="scan'208";a="1002543"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Linux stable kernel release procedure changes
Date: Thu, 2 Dec 2010 19:00:21 -0800
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D6071@wdscexbe08.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux stable kernel release procedure changes
Thread-Index: AcuSgyOCn1g2StFJRHGcrEYhDX8zuwAEdoQQ
References: <20101203004247.GA21762@kroah.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Greg KH" <gregkh@suse.de>
X-OriginalArrivalTime: 03 Dec 2010 03:00:22.0658 (UTC) FILETIME=[3A088E20:01CB9296]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I appreciate the amount of work involved in a "-longterm", and had
been hoping that .37 would be the next candidate.  In addition to
the distros, those of us embedding Linux have enjoyed the ability
to base a variety of products on a common "-longterm" kernel.

I could use some idea of the hours/{week,month} needed for an
experienced kernel maintainer to keep a "-longterm" updated for,
at least, bug fixes from later kernels.

Thank you for your time and effort.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Thursday, December 02, 2010 4:43 PM
> To: linux-kernel@vger.kernel.org; Andrew Morton; 
> torvalds@linux-foundation.org; stable@kernel.org
> Cc: lwn@lwn.net; Andi Kleen; greg@kroah.com
> Subject: Linux stable kernel release procedure changes
> 
> Hi all,
> 
> Over 5 1/2 years ago we started the stable Linux kernel 
> releases, and by
> all merits they seem to be pretty popular.
> 
> The stable series started out as a "once the next release is out, drop
> the old one and move on" type of thing.  This worked really 
> well until I
> decided to have the 2.6.16 be a "longterm" release.  Then I 
> did the same
> thing for the 2.6.27 and later the 2.6.32 release.
> 
> These longterm releases have become very popular for the 
> distros to base
> their work on, and are getting so popular, people are now asking to do
> the same thing for almost all of the recent kernels.
> 
> As this is way beyond the amount of time I have to spend on this, I've
> been discussing with some people how to handle this type of thing.  In
> working through the issues, I've decided that a change is due.
> 
> So, it's "back to our roots" time, and I'm now only going to be doing
> -stable releases for the last kernel released, with the usual 
> one or two
> release overlap with the latest release from Linus to give people a
> chance to move over and have the new release stabilize a bit.
> 
> I'm doing this as it's just way too confusing to try to explain to
> people exactly what kernels are being maintained longer than 
> others, and
> why they are being maintained.  Not to mention the confusion on the
> kernel.org web site where it's hard to tell what kernel release is
> currently being maintained or not.
> 
> I think this is a good thing and will help both the community and
> developers get back on track and focusing on the latest 
> releases and not
> needlessly waste their time on years old kernels that only 
> distros care
> about.
> 
> 
> Oh, wait, what about those older kernels that I said I would maintain
> for a long time?  Don't worry, they are sticking around but they now
> have a new name "longterm" to better reflect what they are.  These
> kernels will have a specific maintainer, and we will show them on the
> kernel.org site in some way to show what exactly is going on 
> with them.
> 
> These longterm kernels will abide by the same stable_kernel_rules.txt
> that I've been using for the older stable rules.
> 
> For now, I'll be continuing to maintain the .27 and .32 kernels as
> "longterm" kernels, but will probably be handing .27 off soon, as I'm
> getting tired of it and my resources are getting limited.
> 
> I already have someone lined up who wants to maintain the .35 
> kernel in
> a longterm manner that I trust, Andi Kleen, and I'll let him write to
> explain his goals for this kernel and what he's going to do.
> 
> 
> Also, as many people have asked about this in the past, I'm 
> now happy to
> announce that the stable@kernel.org email address is now a 
> mailing list
> that anyone can subscribe to in order to see the patches that are sent
> to it, if they wish to comment or maintain their own kernel tree.  I
> will warn you, it's pretty boring, and high volume at times, but hey,
> it's better to work in the open as that's how we need to operate.
> 
> You can subscribe to the list at the following link if you are so
> interested:
> 	http://linux.kernel.org/mailman/listinfo/stable
> 
> 
> So, that's a lot of information, but if anyone has any questions about
> this please let me know.  We're still figuring out what git 
> tree we are
> going to use for the longterm patch queue(s) and where to put the
> releases on the kernel.org site.  Hopefully all that will be 
> hashed out
> in the next week or so.
> 
> thanks,
> 
> greg k-h
> 
> 
> tl;dr:
> 	stable kernel releases only for the last kernel version,
> 	longterm releases for older releases done by me and different
> 	people but with stable_kernel_rules.txt rules, stable@kernel.org
> 	mailing list is now open.
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
