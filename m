Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0EKRiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:38:52 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37958 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0EKRiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:38:50 -0400
Date: Tue, 11 May 2010 19:38:30 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, gregkh@suse.de,
       konrad.wilk@oracle.com, tiwai@suse.de,
       USB list <linux-usb@vger.kernel.org>, clemens@ladisch.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100511173830.GF30801@buzzloop.caiaq.de>
References: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
 <AANLkTikoF4qgkN9p0SpDEOrHAMxdh4jzPusCdrq1tRag@mail.gmail.com>
 <20100511171025.GB30801@buzzloop.caiaq.de>
 <AANLkTimdsIJt69TKf2CgXjEXDJXSNib2jt9JSapmuJyW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimdsIJt69TKf2CgXjEXDJXSNib2jt9JSapmuJyW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 06:32:50PM +0100, Pedro Ribeiro wrote:
> On 11 May 2010 18:10, Daniel Mack <daniel@caiaq.de> wrote:
> > No surprise here. The 4 channels are mux'ed in an interleaved fashion,
> > so if the buffers contain rubbish, you will hear artefacts on all
> > channels.
> 
> So what would be the testcase you would like me to try?

Would be good to see what happens if you could record audio (with
arecord would be sufficient), just to see whether the same problem
exists in the other direction.

Either record an externally generated sine tone and open the resulting
wave file in an editor. With the amount of artefacts you describe, they
should easily be visible.

Another option is to play back any kind of recorded audio thru an audio
device that does not show the problem (some internal, onboard device?).


Thanks,
Daniel
