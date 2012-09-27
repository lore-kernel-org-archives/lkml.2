Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2I0PfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:35:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56835 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2I0PfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:35:19 -0400
Date: Thu, 27 Sep 2012 08:35:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: staging tree closed for 3.7
Message-ID: <20120927153515.GA1555@kroah.com>
References: <20120926175606.GA10762@kroah.com>
 <20120926175634.GB10762@kroah.com>
 <50641CE5.8070107@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50641CE5.8070107@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:31:17AM +0100, Ian Abbott wrote:
> On 2012-09-26 18:56, Greg Kroah-Hartman wrote:
> >On Wed, Sep 26, 2012 at 10:56:06AM -0700, Greg Kroah-Hartman wrote:
> >>
> >>With 3.6 about to be released, I've now closed the 3.7 staging-next tree
> >>for new features / cleanups.  It's bug-fixes only now until 3.7-rc1 is
> >>out.
> >
> >Oh, and if I've missed any patches that people have sent me already,
> >please let me know, because I don't have them anymore.
> 
> I have an outstanding patch for the jr3_pci driver that was mostly
> __iomem tagging, but also included a one-line fix for an invalid
> iomem dereference.  Do you want me to resend the whole patch or just
> split out the one-line fix for 3.6?

The one line fix for now would be great, and then the __iomem one to
apply after that for 3.7 would be also ok.

Can you resend those?

thanks,

greg k-h
