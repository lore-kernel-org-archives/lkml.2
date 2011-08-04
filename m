Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1HDFZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:25:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43619 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770Ab1HDFZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:25:35 -0400
X-Sasl-enc: NsZQoG3oXsrdDTvR/CvINuGpnJr+WBd6u7FEXKJnNJS2 1312435534
Date: Wed, 3 Aug 2011 22:22:39 -0700
From: Greg KH <greg@kroah.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: andrew morton <akpm@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        nbd-general@lists.sourceforge.net
Subject: Re: [PATCH] nbd: nbd sysfs framework
Message-ID: <20110804052239.GA12523@kroah.com>
References: <CAECXXi5kZJk+86-2SJRWqMUCj31cL4tb1qTbaueMxeEg2VFcDw@mail.gmail.com>
 <20110803233426.GA18216@kroah.com>
 <CAECXXi5pkRAY_dVSwSUrj5RQzsJ2YVx6xXovzpuRDOEOq92s9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAECXXi5pkRAY_dVSwSUrj5RQzsJ2YVx6xXovzpuRDOEOq92s9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 10:17:04PM -0400, Paul Clements wrote:
> On Wed, Aug 3, 2011 at 7:34 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Aug 03, 2011 at 07:15:51PM -0400, Paul Clements wrote:
> >> Description: The patch creates a new sysfs entry framework for nbd.
> >
> > Why?  What does this buy us except an increase in code size for no added
> > benifit?  You seem to be stripping out the driver layer here and using
> > "raw" kobjects, why?
> 
> Not sure what I was thinking...just in a hurry, I think.
> 
> Is the following a little better?

I don't know, I still fail to understand _why_ this patch is needed.

Why are you doing this?  What is the goal?  What is wrong with the
existing code that it doesn't work for you?

confused,

greg k-h
