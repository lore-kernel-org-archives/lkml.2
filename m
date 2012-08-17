Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2HQRcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:32:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163Ab2HQRcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:32:15 -0400
Date: Fri, 17 Aug 2012 18:32:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com
Message-ID: <20120817173209.GA29217@decadent.org.uk>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817165109.GA11323@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 09:51:09AM -0700, Greg KH wrote:
> On Thu, Aug 16, 2012 at 06:32:19PM -0700, K. Y. Srinivasan wrote:
> > Now, gather DNS information. Invoke an external script (that can be
> > distro dependent) to gather the DNS information.
> 
> Where is that script?  Why a script, this really isn't in a standard
> method for all Linux distros?  If not, why not work to do that like the
> freedesktop.org people have done for other system configuration items?
 
I suggested using the Network Manager D-Bus API.  That obviously
isn't going to work everywhere, but it seems to cover the same simple
cases that this hypervisor-guest interface allows for.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
