Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2LLAHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:07:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2LLAHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:07:16 -0500
Message-ID: <1355270816.3224.179.camel@bling.home>
Subject: Re: [GIT PULL] VFIO updates for v3.8
From: Alex Williamson <alex.williamson@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        fengguang.wu@intel.com, julia.lawall@lip6.fr, jiang.liu@huawei.com
Date: Tue, 11 Dec 2012 17:06:56 -0700
In-Reply-To: <20121212104632.b01520d6015486dd3ae507ef@canb.auug.org.au>
References: <1355252887.3224.176.camel@bling.home>
	 <20121212104632.b01520d6015486dd3ae507ef@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 10:46 +1100, Stephen Rothwell wrote:
> Hi Linus,
> 
> On Tue, 11 Dec 2012 12:08:07 -0700 Alex Williamson <alex.williamson@redhat.com> wrote:
> >
> > The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:
> > 
> >   Linux 3.7 (2012-12-10 19:30:57 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.8
> > 
> > for you to fetch changes up to a9e3ccfa452c8c5bac49637fe6ece1ac3246d312:
> > 
> >   vfio-pci: Enable device before attempting reset (2012-12-11 11:25:37 -0700)
> 
> This has been rebased from what was in linux-next yesterday onto v3.7.

Is that a bad thing?  I can start tagging from my next branch if that's
preferred.  Thanks,

Alex

