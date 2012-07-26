Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2GZMAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:00:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47073 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab2GZMAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:00:09 -0400
Date: Thu, 26 Jul 2012 12:59:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120726115949.GA29764@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
Thread-Topic: [PATCH 00/36] AArch64 Linux kernel port
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:05:41PM +0100, Catalin Marinas wrote:
> This set of patches implements the core Linux support for the AArch64
> (64-bit ARM) architecture.
...
> These patches are also available on this branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream

Just an update - the 'master' branch in the above Git tree contains the
latest changes following the feedback received so far (and it's not
rebased). The 'upstream' branch has the individual patches as they will
be posted on LKML (it may be rebased). The trees are updated to 3.5.

The Linux port directory has been renamed to arch/arm64/.

I'll be on holiday from tomorrow for nearly two weeks with little access
to email. I plan to post version 2 of the series when I get back, most
likely based on 3.6-rc1.

-- 
Catalin
