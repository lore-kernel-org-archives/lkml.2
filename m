Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2K3U61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:58:27 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:34154 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844Ab2K3U60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:58:26 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, Andy King <acking@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 12/12] VMCI: Some header and config files.
Date: Fri, 30 Nov 2012 12:58:25 -0800
Message-ID: <1666326.N64s5YcnpN@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7+; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121130204406.GB32321@kroah.com>
References: <20121127002357.GA27683@core.coreip.homeip.net> <20121130200940.GA12740@dtor-ws.eng.vmware.com> <20121130204406.GB32321@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 30, 2012 12:44:06 PM Greg KH wrote:
> On Fri, Nov 30, 2012 at 12:09:40PM -0800, Dmitry Torokhov wrote:
> > On Friday, November 30, 2012 10:57:55 AM Greg KH wrote:
> > > On Fri, Nov 30, 2012 at 10:45:44AM -0800, Dmitry Torokhov wrote:
> > > > However you snipped the rest of my reply: do we really need to
> > > > renumber
> > > > ioctls? There is no benefit for the driver as its ioctl handler does
> > > > not parse the numbers into components.
> > > 
> > > I don't know if you need to renumber, I really don't understand what you
> > > were trying to do with this code, and as it was acting differently from
> > > all other kernel ioctl declarations, I asked for some clarity.
> > > 
> > > If you can rewrite it to look sane, and keep the same numbers, that's
> > > fine with me.
> > 
> > OK, it looks like we can redo them as:
> > 
> > #define IOCTL_VMCI_VERSION		_IO(7, 0x9f)    /* 1951 */
> > #define IOCTL_VMCI_INIT_CONTEXT		_IO(7, 0xa0)    /* 1952 */
> > 
> > Is this acceptable?
> 
> Sure, that's better.  You also got lucky, '7' happens to be unused right
> now.

Excellent. You said you want the next drop after -rc1, right?

-- 
Dmitry

