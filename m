Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab2CGTbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:31:20 -0500
Received: from relais.videotron.ca ([24.201.245.36]:64880 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759599Ab2CGTbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:31:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 07 Mar 2012 14:31:06 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Mike Frysinger <vapier@gentoo.org>,
        linux-sh@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
In-reply-to: <20120307190820.GD27213@game.jcrosoft.org>
Message-id: <alpine.LFD.2.02.1203071429060.24151@xanadu.home>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
 <20120307180815.GA27213@game.jcrosoft.org>
 <alpine.LFD.2.02.1203071336210.24151@xanadu.home>
 <20120307190820.GD27213@game.jcrosoft.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 13:50 Wed 07 Mar     , Nicolas Pitre wrote:
> > On Wed, 7 Mar 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > 
> > > On 17:30 Tue 06 Mar     , Stephen Warren wrote:
> > > > This allows the user to use U-Boot's mkimage's -T kernel_noload option
> > > > if their arch Kconfig allows it, and they desire.
> > > > 
> > > > Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> > > > ---
> > > > The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
> > > > that some other architectures will also be able to enable it, but I'm
> > > > not familiar enough with any to know which.
> > > I'm going to repeat. I don't think any impromevent here.
> > 
> > You know what?  I agree with you... on a conceptual level only though.
> > 
> > In reality, some people are are just too used to it, either for 
> > emotional reasons or simply because that's what was there before so they 
> > simply perpetuated it without thinking further, or whatever.  REmoving 
> > that support would just upset a lot of people.  And frankly we have 
> > better things to do than starting a flamewar over this.
> My concern is this new feature is available on new version of U-Boot only
> and people that does not have it and built the uImage are going to ask the
> question. Why bla bla bla....
> 
> Where people are supposed to RTFM
> 
> I do do not want to have the answer this and manage this.

Well, just don't then.


Nicolas
