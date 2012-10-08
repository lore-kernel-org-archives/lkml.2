Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2JHNft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:35:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49833 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2JHNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:35:45 -0400
Date: Mon, 8 Oct 2012 06:35:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
Message-ID: <20121008133539.GA15490@kroah.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-1-git-send-email-kys@microsoft.com>
 <20121008004358.GA12342@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:35:50AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Sunday, October 07, 2012 8:44 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; akpm@linux-foundation.org; andi@firstfloor.org
> > Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
> > 
> > On Sun, Oct 07, 2012 at 04:59:45PM -0700, K. Y. Srinivasan wrote:
> > > The policy engine on the host expects the guest to report the
> > > committed_as. Since this variable is not exported,
> > > export this symbol.
> > 
> > Why are these symbols not needed by either Xen or KVM or vmware, which
> > I think all support the same thing, right?
> 
> The basic balloon driver does not need this symbol since the basic balloon driver
> is not automatically driven by the host. On the Windows host we have a policy engine that
> drives the balloon driver based on both guest level memory pressure that the guest
> reports as well as other system level metrics the host maintains. We need this symbol to
> drive the policy engine on the host.

Ok, but you're going to have to get the -mm developers to agree that
this is ok before I can accept it.

thanks,

greg k-h
