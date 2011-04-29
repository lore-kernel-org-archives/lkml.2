Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758Ab1D2UMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab1D2UMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:12:48 -0400
Date: Fri, 29 Apr 2011 16:12:42 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the cpufreq tree
Message-ID: <20110429201241.GA12256@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110427111024.eb26b6f5.sfr@canb.auug.org.au>
 <20110427013217.GA30804@redhat.com>
 <20110427115427.f5a4fac7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427115427.f5a4fac7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:54:27AM +1000, Stephen Rothwell wrote:
 > Hi Dave,
 > 
 > On Tue, 26 Apr 2011 21:32:17 -0400 Dave Jones <davej@redhat.com> wrote:
 > >
 > > As the commit message suggests, per-arch cpufreq drivers are moving to drivers/cpufreq/
 > > So far, I've only moved the x86 ones.  As a side-effect of this, the 
 > > source "drivers/cpufreq/Kconfig" is no longer a per-arch thing, as it now gets
 > > included from kernel/power/Kconfig.
 > > 
 > > I suspect the warnings are happening because on the unconverted archs, drivers/cpufreq/Kconfig
 > > is now getting included twice.  If you kill the 'source' line in kernel/power/Kconfig,
 > > does this make things go back to normal ?  (Check that cpufreq still shows up in
 > > the resulting config afterwards)
 > 
 > Removing the source line in kernel/power/Kconfig makes the warnings go
 > away and the only change in the generated config file is this:

I've moved this work onto a separate move-drivers branch. Could you track that in next too please?
(Apply after fixes & next)

I'm hoping this branch will be fairly short-lived, but it depends how quickly
other architecture maintainers move their drivers over too.

thanks,

	Dave

