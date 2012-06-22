Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2FVTW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:22:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2FVTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:22:27 -0400
Date: Fri, 22 Jun 2012 12:22:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Alex Lyashkov <umka@cloudlinux.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
Message-ID: <20120622192222.GA22633@kroah.com>
References: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
 <20120622184359.GA25552@kroah.com>
 <20120622185142.GA13225@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622185142.GA13225@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 07:51:42PM +0100, Matthew Garrett wrote:
> On Fri, Jun 22, 2012 at 11:43:59AM -0700, Greg KH wrote:
> 
> > Do you have a pointer to this code anywhere?  Lying about the license to
> > the kernel is a pretty blatent thing to do and I'd like to have some
> > people follow up on that issue.
> 
> http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/x86_64/RPMS/kmod-lve-2.6.18-408.el5.lve1.1.64.2-1.1-10.7.3.el5.x86_64.rpm 
> - there's no corresponding SRPM in 
> http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/SRPMS/ and 
> upstream apparently refuse to provide source. Alex Lyashkov (Cc:ed) is 
> listed as module author in the metadata.

Hm, and at least one reason it needs to be GPL is due to it using
symbols I created, no fun.

Alex, can you please provide the source code for this module?  Or is the
license that the code is saying it is, somehow incorrect?  If so, can
you please fix it?  If you can't do this, is there someone else I should
be contacting?

thanks,

greg k-h
