Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0EFLKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:10:46 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:51925 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165Ab0EFLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:10:44 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2010 07:10:44 EDT
To: linux-kernel@vger.kernel.org, gnome-announce-list@gnome.org,
       performance-list@gnome.org
Subject: Announce: Sysprof 1.1.6 CPU profiler for Linux
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 06 May 2010 13:04:17 +0200
Message-ID: <ye8hbmlthou.fsf@camel27.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.146
X-Sim: 5e63ab2b8a98890c419b49b55696b3c6648adabf4a42b5e4219346a3cbfce84f
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysprof 1.1.6 is now available. This is a development release leading
up to a stable 1.2.0 release.

Sysprof is a sampling system-wide CPU profiler for Linux. This
version is based on the perf counter interface in 2.6.31 kernels and
will not work with earlier kernels.

News since 1.1.4:

- Fix for the "mmap failed" error
- More reliable output on multi-core CPUs
- Misc. bug fixes


Version 1.1.6 is a development release. Please report bugs to
sandmann@daimi.au.dk


Download:               http://sysprof.com/sysprof-1.1.6.tar.gz

Sysprof web site:       http://sysprof.com/

Git:                    git://git.gnome.org/sysprof


Thanks,
Soren
