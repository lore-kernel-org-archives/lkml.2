Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab1D0Clw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab1D0Clu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:41:50 -0400
Date: Tue, 26 Apr 2011 22:41:46 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the cpufreq tree
Message-ID: <20110427024145.GB30804@redhat.com>
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
 > Removing the source line in kernel/power/Kconfig makes the warnings go
 > away and the only change in the generated config file is this:
 > 
 > @@ -465,10 +465,6 @@
 >  # CONFIG_PM_RUNTIME is not set
 >  CONFIG_PM=y
 >  # CONFIG_PM_DEBUG is not set
 > -
 > -#
 > -# CPU Frequency scaling
 > -#
 >  CONFIG_SECCOMP=y
 >  CONFIG_ISA_DMA_API=y

Ok, thanks for testing. I'll fix something up.

	Dave

