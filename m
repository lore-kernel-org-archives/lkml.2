Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab2EaRin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:38:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25120 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2EaRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:38:42 -0400
Date: Thu, 31 May 2012 13:31:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/mce: Add mcelog support for Xen
 platform
Message-ID: <20120531173137.GA31735@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
 <20120531161139.GA13939@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351FFB11@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FFB11@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 05:27:53PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Thu, May 31, 2012 at 12:57:44PM +0000, Liu, Jinsong wrote:
> >>> From 1a7951d6ca01d7f2c9dd2bdb6de5f8e7fdcb8bbd Mon Sep 17 00:00:00
> >>> 2001 
> >> From: root <root@ljsromley.bj.intel.com>
> > 
> > Also your git author is busted. I fixed it up for you but
> > you might want to run 'git config --user.name' and such
> 
> Ah, I forgot it. Thanks for fix it.
> 
> > 
> >> Date: Fri, 1 Jun 2012 03:12:51 +0800
> >> Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
> > 
> > What about the cvt_gate_to_trap? Does that need something similar
> > to "xen/mce: Register native mce handler as vMCE bounce back point"
> > ?
> 
> That's vMCE injection logic.

Are you sure about it? The comments in it speak of piggybacking on
the native MCE handling routines. But since that is not used anymore
do you need to use a different mechanism?

> anyway, I will present new round of patch according to Boris and your commends, as following
> [Patch 1/3] xen-mce-Add-mcelog-support-for-Xen-platform.patch
> [Patch 2/3] X86-MCE-AMD-Adjust-initcall-sequence-for-xen.patch
> [Patch 3/3] Register-native-mce-handler-as-vMCE-bounce-back-poin.patch

Please look at http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commit;h=894c02d298cb638f3ff04bdbf41f646a0223bf05 as it has some of the mistakes fixed (spelling mistakes, wrong title, etc).

> 
> Patch 1/3 and 2/3 are for mcelog
> Patch 3/3 are for vMCE injection
> 
> > 
> > I stuck all these patches on devel/mce.v2 on
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
> 
> Hmm, we discussed base-tree problem before, and decided to use linus latest tree.
> I pull this morning and rebase my patches based on
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> c/s a01ee165a132fadb57659d26246e340d6ac53265

Which I think the tree is based on too.
