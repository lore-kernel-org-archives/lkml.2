Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1BYBHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:07:05 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:23528 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab1BYBHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:07:04 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH ] Staging: hv:  Hyper-V driver cleanup
Thread-Topic: [PATCH ] Staging: hv:  Hyper-V driver cleanup
Thread-Index: AQHL1HhK+lfYpnoGuE66PtEGdw/CRJQR1w+A//+AWICAAIx8AP//e0CQ
Date: Fri, 25 Feb 2011 01:07:02 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048015256@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1298589658-23126-1-git-send-email-kys@microsoft.com>
 <20110224234541.GA23711@suse.de>
 <6E21E5352C11B742B20C142EB499E04801522A@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110225003136.GA27272@suse.de>
In-Reply-To: <20110225003136.GA27272@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, February 24, 2011 7:32 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> Subject: Re: [PATCH ] Staging: hv: Hyper-V driver cleanup
> 
> On Fri, Feb 25, 2011 at 12:24:57AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Thursday, February 24, 2011 6:46 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> > > Subject: Re: [PATCH ] Staging: hv: Hyper-V driver cleanup
> > >
> > > On Thu, Feb 24, 2011 at 03:20:58PM -0800, K. Y. Srinivasan wrote:
> > > > This patch cleans up (a lot of the) naming issues that
> > > > various reviewers have noted. It also gets rid of
> > > > some unnecessary layering in the code.
> > >
> > > Whenever you have a patch description that says "It also..." you know
> > > you need to break this up into smaller, logical pieces.
> >
> > The name change was related to the layering issue. For instance I combined the
> > Vm_device and hv_device abstractions to build the hyperv_device abstraction.
> > Likewise, I combined the driver_context and the hv_driver abstractions to build
> the
> > the hyperv_driver abstraction. Would breaking this patch up into two patches,
> > one dealing with the device abstraction consolidation and the other dealing
> with
> > the consolidation of driver abstractions satisfy your concern. Even if I partition
> this
> > patch along these lines, it will still be a large set of patches; since these changes
> > are pervasive.
> 
> pervasive patches are fine, just remember, "each patch can only do one
> thing".  It sounds like you want to do at least 2 patches here, if not
> a lot more.  Look at my past patches when I combined things and removed
> a whole layer for how to do this in a very incremental, piece-by-piece
> fashion (i.e, move one field over at a time until the structure is gone,
> and then remove it entirely.)


If it is ok with you, I will do two patches - one for dealing with consolidating device structure
and the other for consolidating the driver abstractions. 
  
> 
> > > There is no 2.6.38 kernel yet, so I find this very hard to believe :)
> >
> > My mistake; I did not specify the full output of uname -a on the box
> > that I tested this code. This box is running the LINUX-NEXT kernel :
> > 2.6.38-rc1-0.2-default.
> 
> linux-next should be farther along than -rc1 as -rc6 is currently out.

While the hv code is from the tip of the tree; the kernel I am running is a little dated.

Regards,

K. Y
> 
> confused,
> 
> greg k-h

