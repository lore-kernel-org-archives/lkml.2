Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0HJWGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:06:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab0HJWG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:06:29 -0400
Date: Tue, 10 Aug 2010 23:06:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: torvalds@linux-foundation.org, Erik Gilling <konkers@google.com>,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org, davidb@codeaurora.org
Subject: Re: [GIT PULL] Initial Tegra ARM support
Message-ID: <20100810220600.GD7702@n2100.arm.linux.org.uk>
References: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com> <1281476664.9400.36.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281476664.9400.36.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 02:44:24PM -0700, Daniel Walker wrote:
> On Thu, 2010-08-05 at 14:10 -0700, Erik Gilling wrote:
> > Hi Linus,
> > 
> > The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
> >   Linus Torvalds (1):
> >         Linux 2.6.35
> > 
> > are available in the git repository at:
> > 
> >   git://android.kernel.org/kernel/tegra.git for-linus
> > 
> > This code has received review on linux-arm-kernel and has been in
> > for-next since June 18th.  No subsystems were harmed out side of
> > mach-tegra.
> > 
> > Colin Cross (4):
> >       [ARM] tegra: Add clock support
> >       [ARM] tegra: SMP support
> 
> 
> This fixes some typos in the Tegra tree which caused build failures in
> all ARM compiles.

Argh, no, not another patch doing this the wrong way.  I've fixed this
already, just preparing the pull request for this evening.
