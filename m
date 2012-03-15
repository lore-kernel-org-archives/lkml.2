Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2CODlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 23:41:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab2CODlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 23:41:36 -0400
Date: Wed, 14 Mar 2012 23:41:12 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kevin Hilman <khilman@ti.com>, Jaecheol Lee <jc.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the cpufreq tree with the
 cpufreq-current tree
Message-ID: <20120315034111.GA31961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Kevin Hilman <khilman@ti.com>, Jaecheol Lee <jc.lee@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
References: <20120315132352.b8c8bbf0242c1f3b31333675@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315132352.b8c8bbf0242c1f3b31333675@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 01:23:52PM +1100, Stephen Rothwell wrote:
 > Hi Dave,
 > 
 > Today's linux-next merge of the cpufreq tree got a conflict in
 > drivers/cpufreq/Makefile between commit b09db45c56c2 ("cpufreq: OMAP
 > driver depends CPUfreq tables") from the cpufreq-current tree and commit
 > a35c50510dd4 ("EXYNOS4X12: Add support cpufreq for EXYNOS4X12") from the
 > cpufreq tree.
 > 
 > Just context changes.  I fixed it up (see below) and can carry the fix as
 > necessary.

Argh, I've managed to get "for 3.4" patches on my fixes branch by mistake.
Given how close we are to 3.3 now, I'll just have Linus pull both branches
when 3.4 opens up.

thanks for catching this.

	Dave
