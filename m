Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0LaLVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 06:21:40 -0500
Received: from smtp.tele.fi ([192.89.123.25]:38070 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab0LaLVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 06:21:39 -0500
X-Originating-Ip: [194.89.68.22]
Date: Fri, 31 Dec 2010 13:20:43 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: Vasiliy G Tolstov <v.tolstov@selfip.ru>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, haicheng.li@linux.intel.com,
        dan.magenheimer@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi.kleen@intel.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com
Subject: Re: [Xen-devel] Re: [PATCH 2/3] drivers/xen/balloon.c: Various
	balloon features and fixes
Message-ID: <20101231112043.GZ2754@reaktio.net>
References: <20101220134724.GC6749@router-fw-old.local.net-space.pl> <20101227150847.GA3728@dumpdata.com> <947c7677e042b3fd1ca22d775ca9aeb9@imap.selfip.ru> <20101227163918.GB7189@dumpdata.com> <92e9dd494cc640c04fdac03fa6d10e8d@imap.selfip.ru> <20101229164910.GD2743@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229164910.GD2743@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 05:49:10PM +0100, Daniel Kiper wrote:
> Hi,
> 
> On Tue, Dec 28, 2010 at 12:52:03AM +0300, Vasiliy G Tolstov wrote:
> > On Mon, 27 Dec 2010 11:39:18 -0500, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > > On Mon, Dec 27, 2010 at 07:27:56PM +0300, Vasiliy G Tolstov wrote:
> > >> On Mon, 27 Dec 2010 10:08:47 -0500, Konrad Rzeszutek Wilk
> > >> <konrad.wilk@oracle.com> wrote:
> > >> > On Mon, Dec 20, 2010 at 02:47:24PM +0100, Daniel Kiper wrote:
> > >> >> Features and fixes:
> > >> >>   - HVM mode is supported now,
> > >> >>   - migration from mod_timer() to schedule_delayed_work(),
> > >> >>   - removal of driver_pages (I do not have seen any
> > >> >>     references to it),
> > >> >>   - protect before CPU exhaust by event/x process during
> > >> >>     errors by adding some delays in scheduling next event,
> > >> >>   - some other minor fixes.
> > >>
> > >> I have apply this patch to bare 2.6.36.2 kernel from kernel.org. If
> > >> memory=maxmemory pv guest run's on migrating fine.
> > >> If on already running domU i have xm mem-max xxx 1024 (before that it
> > >> has 768) and do xm mem-set 1024 guest now have 1024 memory, but after
> > >> that it can't migrate to another host.
> 
> Do you still need memory hotplug patch for jeremy stable-2.6.32.x ???
> 

I think it would be good to have it for xen/stable-2.6.32.x aswell!
(that's the tree that's used the most atm).

-- Pasi

