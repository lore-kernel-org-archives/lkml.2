Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0JYVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:16:56 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:39609 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0JYVQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:16:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v4 6/6] x86: allocate space within a region top-down
Date: Mon, 25 Oct 2010 15:15:29 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert@redhat.com>
References: <20101014231804.536.62138.stgit@bob.kio> <20101025140154.66f1e1bd@jbarnes-desktop> <201010251508.49165.bjorn.helgaas@hp.com>
In-Reply-To: <201010251508.49165.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010251515.30491.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 25, 2010 03:08:48 pm Bjorn Helgaas wrote:
> On Monday, October 25, 2010 03:01:54 pm Jesse Barnes wrote:
> > On Thu, 14 Oct 2010 17:18:52 -0600
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > 
> > > 
> > > Request that allocate_resource() use available space from high addresses
> > > first, rather than the default of using low addresses first.
> > > 
> > > The most common place this makes a difference is when we move or assign
> > > new PCI device resources.  Low addresses are generally scarce, so it's
> > > better to use high addresses when possible.  This follows Windows practice
> > > for PCI allocation.
> > 
> > Applied this series to linux-next; assuming nothing blows up I'll send
> > it to Linus this week (previous versions got some testing and landed in
> > a separate branch so this should be fine).
> 
> We tripped over another issue in Fedora:
>   https://bugzilla.redhat.com/show_bug.cgi?id=646027

By the way, it's been a *great* help to have Fedora being willing to
go out on a limb and help get these tested.  I know it sucks to get
those Rawhide bug reports, but they have been extremely useful to me.
Thanks!

Bjorn
