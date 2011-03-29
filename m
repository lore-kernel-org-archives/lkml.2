Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1C2XUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:20:46 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:29785
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab1C2XUo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:20:44 -0400
X-SpamScore: -42
X-BigFish: VPS-42(zzbb2cK542N1432N98dN1451L4015L148cM9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: xilinx linux-next tree addition request
Date: Tue, 29 Mar 2011 17:18:08 -0600
In-Reply-To: <20110330101353.40d40776.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: xilinx linux-next tree addition request
Thread-Index: AcvuZ0UaxN4Nm7L2RA6IdnVDsIfLPQAAC54A
References: <58f8b399-ac49-484c-9e99-d23bcda08a8b@VA3EHSMHS024.ehs.local> <20110330101353.40d40776.sfr@canb.auug.org.au>
From: John Linn <linnj@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 29 Mar 2011 23:18:09.0879 (UTC) FILETIME=[9168AE70:01CBEE67]
Message-ID: <0f926f00-14c5-44b3-b105-d88a5d21cdb7@VA3EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Tuesday, March 29, 2011 5:14 PM
> To: John Linn
> Cc: linux-next@vger.kernel.org; LKML; grant.likely@secretlab.ca
> Subject: Re: xilinx linux-next tree addition request
> 
> Hi John,
> 
> On Fri, 25 Mar 2011 14:35:12 -0600 John Linn <John.Linn@xilinx.com>
> wrote:
> >
> > I have a tree I'd like to see show up in linux-next:
> >
> > git://git.xilinx.com/linux-2.6-xlnx.git arm-next
> >
> > After v2.6.39-rc1 is released, it will contain Xilinx ARM work
> > intended for the 2.6.40 merge window.  Everything in there has been
> > posted, reviewed, fixed, etc...
> >
> > If order makes a difference, it would be best if it's after
Russell's
> > tree as it could have dependencies on stuff in his tree.
> 
> This will be added from today (I was waiting for -rc1).  I have put
you
> down as the contact, if you want any additional people/lists, then
just
> let me know.

Great, appreciate the help.

> 
> Thanks for adding your subsystem tree as a participant of linux-next.
> As you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
> 
> You will need to ensure that the patches/commits in your tree/series
> have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask
him
> to fetch).  It is allowed to be rebased if you deem it necessary.

Of course, agreed.

Thanks,
John

> 
> --
> Cheers,
> Stephen Rothwell
> sfr@canb.auug.org.au
> 
> Legal Stuff:
> By participating in linux-next, your subsystem tree contributions are
> public and will be included in the linux-next trees.  You may be sent
> e-mail messages indicating errors or other issues when the
> patches/commits from your subsystem tree are merged and tested in
> linux-next.  These messages may also be cross-posted to the linux-next
> mailing list, the linux-kernel mailing list, etc.  The linux-next tree
> project and IBM (my employer) make no warranties regarding the linux-
> next project, the testing procedures, the results, the e-mails, etc.
> If you don't agree to these ground rules, let me know and I'll remove
> your tree from participation in linux-next.

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


