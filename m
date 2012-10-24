Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab2JXJxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:53:39 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38225 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2JXJxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:53:38 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15353140"
Message-ID: <1351072415.2237.137.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V5] PVH patches for v3.8.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 10:53:35 +0100
In-Reply-To: <5087D4A102000078000A3E23@nat28.tlf.novell.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
	 <5087B13402000078000A3CBB@nat28.tlf.novell.com>
	 <1351071279.2237.126.camel@zakaz.uk.xensource.com>
	 <5087D4A102000078000A3E23@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 10:44 +0100, Jan Beulich wrote:
> >>> On 24.10.12 at 11:34, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > On Wed, 2012-10-24 at 08:13 +0100, Jan Beulich wrote:
> > 
> >> >  include/xen/interface/memory.h       |   29 ++++++-
> >> >  include/xen/interface/physdev.h      |   10 ++
> >> 
> >> ... any changes to the hypervisor interface (didn't look in detail
> >> what is being changed in these two headers) should first be in
> >> at least -unstable before being consumed in any official release
> >> imo.
> > 
> > I'd also like to see at least the interface definitions in the h/v tree
> > if not the implementation right away.
> > 
> > The flip side is that we have agreed that the interfaces are not
> > considered set in stone / stable until we've had a chance to review the
> > implementation, so perhaps it is better not to commit them to
> > xen-unstable.hg right away.
> > 
> > I don't know what the right answer is. Perhaps we should at a minimum
> > reserve the subop numbers even if we don't yet define what they mean in
> > the Xen tree.
> 
> But even then - what use is it to have 3.8 possibly only work on
> some intermediate (perhaps even just privately built) hypervisors?

Mukesh was having trouble keeping up with rebasing both the Linux and
Xen sides simultaneously to keep up with development, so he decided to
concentrate on getting the Linux side in first.

Ian.

