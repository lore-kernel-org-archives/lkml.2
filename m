Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966380Ab2JZUL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:11:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:40589 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966327Ab2JZULZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:11:25 -0400
Date: Fri, 26 Oct 2012 13:11:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy King <acking@vmware.com>
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        George Zhang <georgezhang@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
Message-ID: <20121026201123.GA15366@kroah.com>
References: <723255296.2652440.1351199329247.JavaMail.root@vmware.com>
 <1734741434.3740170.1351281773036.JavaMail.root@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1734741434.3740170.1351281773036.JavaMail.root@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:02:53PM -0700, Andy King wrote:
> Hi Greg,
> 
> > in the next few days with that change along with any modifications
> > necessary after a sparse sanity check.
> 
> We have a change that fixes things, but I wanted to check if you
> had any additional comments before we send out more patches.  In
> all likelihood you'd probably already given up in disgust after
> the vanilla exports, but I wanted to be sure :)

Yes, I stopped reviewing at this point.

> Also, would you prefer a complete refresh of the series or just
> diffs?

Complete refresh, with a short summary on the 00/10 patch of what the
changes are.  That's the usual way to do this type of thing.

thanks,

greg k-h
