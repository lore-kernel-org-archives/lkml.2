Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2BWXQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:16:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43172 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab2BWXQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:16:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.220.196 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 23 Feb 2012 15:16:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223231605.GA15329@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <20120222211928.GA4448@kroah.com>
 <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
 <20120222213253.GA25150@kroah.com>
 <20120223200905.GA5475@kroah.com>
 <4F46A1C4.90506@zytor.com>
 <20120223204832.GA30322@kroah.com>
 <4F46A6EC.8050804@zytor.com>
 <20120223211016.GA16275@kroah.com>
 <4F46C63C.4040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F46C63C.4040602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:05:32PM -0800, H. Peter Anvin wrote:
> On 02/23/2012 01:10 PM, Greg Kroah-Hartman wrote:
> >>
> >> That would be awesome.
> > 
> > Ok, the patches are at:
> > 	git.kernel.org/pub/scm/linux/kernel/git/gregkh/stable-test.git linux-3.2.y-i387-test
> > 
> > They are on top of the 3.2.7 kernel release.
> > 
> > If that doesn't work for you, please let me know.
> > 
> 
> This is a bit odd.
> 
> I don't see the user space FPU corruption I did with the old code, but
> the wifi drops off the network and won't come back after running for
> quite a while.  It might be coincidence, but I have had it happen a few
> times now.

And a "clean" 3.2.7 doesn't have that problem?

Does the same thing happen in Linus's tree at the moment?

greg k-h
