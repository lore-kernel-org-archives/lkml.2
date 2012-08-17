Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab2HQRix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:38:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57370 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2HQRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:38:47 -0400
Date: Fri, 17 Aug 2012 10:38:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
Message-ID: <20120817173837.GA3080@kroah.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
 <20120817173209.GA29217@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817173209.GA29217@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 06:32:09PM +0100, Ben Hutchings wrote:
> On Fri, Aug 17, 2012 at 09:51:09AM -0700, Greg KH wrote:
> > On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > > Now, gather DNS information. Invoke an external script (that can be
> > > distro dependent) to gather the DNS information.
> > 
> > Where is that script?  Why a script, this really isn't in a standard
> > method for all Linux distros?  If not, why not work to do that like the
> > freedesktop.org people have done for other system configuration items?
>  
> I suggested using the Network Manager D-Bus API.  That obviously
> isn't going to work everywhere, but it seems to cover the same simple
> cases that this hypervisor-guest interface allows for.

That's a great start, as I think all of the distros have now pretty much
standardized on this format, right?

greg k-h
