Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363Ab2J3T7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:59:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33231 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2J3T7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:59:50 -0400
Date: Tue, 30 Oct 2012 12:59:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 00/12] VMCI for Linux upstreaming
Message-ID: <20121030195945.GA32243@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030021938.GC1920@kroah.com>
 <20121030040744.GB32055@dtor-ws.eng.vmware.com>
 <20121030154801.GC14167@kroah.com>
 <20121030161807.GA9709@dtor-ws.eng.vmware.com>
 <20121030162723.GA16135@kroah.com>
 <20121030194354.GA32137@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030194354.GA32137@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 12:43:54PM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 30, 2012 at 09:27:23AM -0700, Greg KH wrote:
> > On Tue, Oct 30, 2012 at 09:18:07AM -0700, Dmitry Torokhov wrote:
> > > > > I think that even if we had a special directory for vmci having network
> > > > > drivers in Dave's realm and pvscsi in James's is best option, so the new
> > > > > directory would contain vmci and the balloon driver (vsock will go into
> > > > > net/).  Given that balloon is already in drivers/misc it looked like
> > > > > obvious place for VMCI as well.
> > > > 
> > > > I agree that the individual drivers should go in the subsystem area,
> > > > it's this "hypervisor bus core" type code that I'm questioning.  Right
> > > > now every hypervisor is putting that logic in a different place in the
> > > > kernel, having some consistency here would be nice.
> > > 
> > > Hmm, I wonder if miscellaneous and core hypervisor drivers should end
> > > up in drivers/platform:
> > > 
> > > 	drivers/platform/hyperv
> > > 	drivers/platform/olpc
> > > 	drivers/platform/vmware
> > > 	drivers/platform/xen
> > > 	drivers/platform/x86
> > 
> > That makes sense to me, nice.
> > 
> > > But really we'd like to get VMCI into mainline first and move to a new
> > > place later if such a better place is found.
> > 
> > Heh, no one wants to fight for something to help everyone out, they just
> > want their own code accepted :)
> 
> No, this is more about finding a person who would be maintaining it and
> thus would review our code. For now we got you tagged and do not want to
> let go of you :P
> 
> Or should we maintain our own stuff and have Linus pull it directly,
> like Xen guys appear to be doing? Really, moving it is not an issue for
> us.

No, I don't mind doing some of the review, and getting it to Linus to
start with, but over time, having you all be the owners and push stuff
directly to him is fine with me.

So I agree, for now, let's leave it as-is.

thanks,

greg k-h
