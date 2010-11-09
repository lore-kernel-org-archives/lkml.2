Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0KIReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:34:06 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57798 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0KIReD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:34:03 -0500
Date: Tue, 9 Nov 2010 09:33:57 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>
Subject: [linux-next] automatic use of checkpatch.pl for security?
Message-ID: <20101109173357.GA5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In an effort to continue the constification work, it'd be nice to
not accidentally introduce regressions or add additional work. Since
checkpatch.pl already knows to warn about a lot of things including const
structures, it would be great to have all commits going through linux-next
(or something) have to pass at least a subset of checkpatch.pl's checks.

For example, Lionel Debroux pointed out to me that looking at the last
1000 commits, there are a lot of warnings, including things like:

WARNING: struct dma_map_ops should normally be const
#499: FILE: arch/mips/mm/dma-default.c:301:
+static struct dma_map_ops mips_default_dma_map_ops = {

Can we add some kind of automatic checking to actually give checkpatch.pl
some real teeth for at least some of its checks?

-Kees

-- 
Kees Cook
Ubuntu Security Team
