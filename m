Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1BGEOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:14:55 -0500
Received: from xenotime.net ([72.52.115.56]:39220 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754361Ab1BGEOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:14:54 -0500
Date: Sun, 6 Feb 2011 20:14:48 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Simon Horman <horms@verge.net.au>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH -next] Documentation: Improve crashkernel= description
Message-Id: <20110206201448.4a259575.rdunlap@xenotime.net>
In-Reply-To: <20110206215733.GB26233@verge.net.au>
References: <20110206154108.GA16542@laptop>
	<20110206215733.GB26233@verge.net.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011 06:57:33 +0900 Simon Horman wrote:

> On Sun, Feb 06, 2011 at 05:41:08PM +0200, Ahmed S. Darwish wrote:
> > (Also applicable over 2.6.38-rc3)
> > 
> > Had to explore two C code files to make sense of the 'crashkernel='
> > kernel parameter values.  Improve the situation.
> > 
> > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> > ---
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 89835a4..8f26b42 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -545,9 +545,12 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			Format:
> >  			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
> >  
> > -	crashkernel=nn[KMG]@ss[KMG]
> > -			[KNL] Reserve a chunk of physical memory to
> > -			hold a kernel to switch to with kexec on panic.
> > +	crashkernel=size[KMG][@offset[KMG]]
> > +			[KNL] Using kexec, Linux can switch to a 'crash kernel'
> > +			upon panic. This parameter reserves the physical
> > +			memory region [offset, offset + size] for that kernel
> > +			image. If the '@offset' part was ignored, Linux finds
> > +			a suitable crash image start address automatically.
> 
> I think this would be further improved as:
> 
> 			... If '@offset' is omitted then a suitable
> 			offset is selected automatically.
> 
> >  
> >  	crashkernel=range1:size1[,range2:size2,...][@offset]
> >  			[KNL] Same as above, but depends on the memory

Hi,

I also prefer Simon's change.  Can you please resend an updated patch?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
