Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2J3EHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:07:46 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52393 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab2J3EHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:07:45 -0400
Date: Mon, 29 Oct 2012 21:07:44 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 00/12] VMCI for Linux upstreaming
Message-ID: <20121030040744.GB32055@dtor-ws.eng.vmware.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030021938.GC1920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030021938.GC1920@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Oct 29, 2012 at 07:19:38PM -0700, Greg KH wrote:
> On Mon, Oct 29, 2012 at 06:03:28PM -0700, George Zhang wrote:
> >  drivers/misc/Kconfig                      |    1
> >  drivers/misc/Makefile                     |    2
> >  drivers/misc/vmw_vmci/Kconfig             |   16
> >  drivers/misc/vmw_vmci/Makefile            |   43
> 
> Meta comment here, why drivers/misc/?  The other hypervisor
> infrastructures all have their own directory under drivers/  Should we
> be moving everything to drivers/hyperv/ somehow?

drivers/hyperv is not the best name for obvious reasons...

I think that even if we had a special directory for vmci having network
drivers in Dave's realm and pvscsi in James's is best option, so the new
directory would contain vmci and the balloon driver (vsock will go into
net/).  Given that balloon is already in drivers/misc it looked like
obvious place for VMCI as well.

Thanks,
Dmitry

