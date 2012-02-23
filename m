Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2BWXy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:54:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56100 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2BWXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:54:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.212.3 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 23 Feb 2012 15:54:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223235450.GA22345@kroah.com>
References: <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
 <20120222213253.GA25150@kroah.com>
 <20120223200905.GA5475@kroah.com>
 <4F46A1C4.90506@zytor.com>
 <20120223204832.GA30322@kroah.com>
 <4F46A6EC.8050804@zytor.com>
 <20120223211016.GA16275@kroah.com>
 <4F46C63C.4040602@zytor.com>
 <20120223231605.GA15329@kroah.com>
 <4F46C92B.4090508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F46C92B.4090508@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:18:03PM -0800, H. Peter Anvin wrote:
> On 02/23/2012 03:16 PM, Greg Kroah-Hartman wrote:
> > 
> > And a "clean" 3.2.7 doesn't have that problem?
> > 
> > Does the same thing happen in Linus's tree at the moment?
> > 
> 
> Clean 3.2.7 I don't think has that problem, although of course when I
> run the stress test it fails on other ways so it's hard to 100% rule out.
> 
> Linus' tree doesn't have that problems.

Ugh.

So, we need more testers, so let me release a -rc kernel with just these
changes in it, to get a wider testing range, and make an easy "this
kernel worked, but this one didn't" for people to work with.

I don't suppose that 'git bisect' would work for this, as it's really a
"all or nothing" type thing with this series from what I can tell,
right?

thanks,

greg k-h
