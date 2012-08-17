Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2HQRRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:17:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64642 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab2HQRRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:17:37 -0400
Date: Fri, 17 Aug 2012 10:17:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
Message-ID: <20120817171728.GA14288@kroah.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9236C1E63@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9236C1E63@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 05:07:22PM +0000, KY Srinivasan wrote:
> > On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > > Now, gather DNS information. Invoke an external script (that can be
> > > distro dependent) to gather the DNS information.
> > 
> > Where is that script?  Why a script, this really isn't in a standard
> > method for all Linux distros?  If not, why not work to do that like the
> > freedesktop.org people have done for other system configuration items?
> 
> We debated this issue on this mailing list for a long time. The consensus was that
> we would invoke  external "distro" specific scripts for both configuring the interface
> as well as gathering information that could not be gathered in a distro independent
> fashion. That is what I have implemented here. This code specifies the interface to this
> external script. If these external scripts are not there, it is not fatal - on the SET side,
> the interface will not be configured and on the get side some attributes that are to be 
> gathered via these external scripts will not be collected.

I've applied the first 7 patches here, feel free to submit the rest when
you answer the other questions I asked as well.

greg k-h
