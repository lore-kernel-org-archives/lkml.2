Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab2JYVX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:23:56 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:56235 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab2JYVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:23:54 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, Andy King <acking@vmware.com>,
        vm-crosstalk@vmware.com, linux-kernel@vger.kernel.org,
        George Zhang <georgezhang@vmware.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
Date: Thu, 25 Oct 2012 14:13:24 -0700
Message-ID: <13812664.FoGKxWEYdK@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121025210448.GB12352@kroah.com>
References: <20121025192851.GA26627@kroah.com> <1635399.c93qq9Svfo@dtor-d630.eng.vmware.com> <20121025210448.GB12352@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2012 02:04:48 PM Greg KH wrote:
> On Thu, Oct 25, 2012 at 01:45:39PM -0700, Dmitry Torokhov wrote:
> > On Thursday, October 25, 2012 01:31:48 PM Greg KH wrote:
> > > On Thu, Oct 25, 2012 at 01:16:00PM -0700, Andy King wrote:
> > > > Hi Greg,
> > > > 
> > > > > > +EXPORT_SYMBOL(vmci_device_get);
> > > > > 
> > > > > EXPORT_SYMBOL_GPL() for this, and all other exports?
> > > > 
> > > > We'd prefer to leave them as vanilla exports.  While we're committed
> > > > to open-sourcing everything, including our non-upstreamed drivers,
> > > > we don't really have a strong opinion regarding consuming our exports
> > > > in closed-source (general GPL issues aside).
> > > 
> > > You can't just say "general GPL issues aside".  Honestly, given your
> > > company's prior actions in regards to Linux kernel drivers and the
> > > licenses of them, I don't trust them at all.  To help gain that trust
> > > back, marking the exports in this manner will be a great improvement.
> > > 
> > > To insist otherwise is to only reinforce my doubts, and reduce my
> > > wanting to even review or accept this code at all.  Sorry about that.
> > 
> > Huh? What are the concerns exactly? I do not really see difference between
> > EXPORT_SYMBOL() and EXPORT_SYMBOL_GPL(). The code either derivative of the
> > kernel or it is not and so it either falls under the kernel license or
> > not.
> 
> I totally agree.  In this case, do you think it falls under the kernel
> license or not?

VMCI implementation that we are submitting is GPL as witnessed by the license
notices on the source files ;)

> 
> > From out perspective we do not really care what other code might use VMCI,
> > all our Linux drivers, even if not all are upstream [yet], are GPL.
> 
> That's nice to hear, although without proof of that, we have to take
> your word :)

The source to Open VM Tools (which includes guest drivers that have not
been upstreamed yet) can be always found here:

	https://sourceforge.net/projects/open-vm-tools/files/

and here:

	git.opensource.vmware.com/opensource/open-vm-tools/

The hosted drivers are distributed in source form with the product and
here:

https://my.vmware.com/web/vmware/info/slug/desktop_end_user_computing/vmware_workstation/9_0#open_source
	
Thanks,
Dmitry
	



> 
> thanks,
> 
> greg k-h
