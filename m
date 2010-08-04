Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0HDRJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:09:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773Ab0HDRJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:09:36 -0400
Date: Wed, 4 Aug 2010 10:04:06 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Message-ID: <20100804170406.GA28217@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173732.GA1455@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:35:06AM +0000, Hank Janssen wrote:
> 
> And then Greg spoke:
> >>On Tue, Aug 03, 2010 at 05:31:51PM +0000, Hank Janssen wrote:
> >> From: Hank Janssen <hjanssen@microsoft.com>
> >> 
> > >Fixed bounce offset kmap problem by using correct index
> >
> >Is this a bugfix that needs to go to previous kernel releases?  If so, which ones?  What is the symptom of the problem here?
> 
> Yes, this should be backported to all stable kernel releases that have the Hyper-V drivers In them.  
> 
> The symptom of the problem is that in some NAS appliances this problem represents
> Itself by a unresponsive VM under a load with many clients writing small files.
> 
> I actually goofed up in my previous code and used an incorrect index number
> For this part of the code. It should have shown up in more situations than what
> I have seen oddly enough.

Please provide this type of information in the changelog section.

If you want something backported to older stable kernels, add a:
	Cc: stable <stable@kernel.org>
to the signed-off-by area of the patch and it will be automatically sent
to the stable alias when it gets included in Linus's tree so I know to
pick it up then.

Care to resend all of these patches based on these comments?

thanks,

greg k-h
