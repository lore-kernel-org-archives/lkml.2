Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2DXVjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:39:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40903 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab2DXVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:39:41 -0400
Date: Tue, 24 Apr 2012 22:39:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-drivers-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 platform driver fixes
Message-ID: <20120424213937.GA26670@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One annoyance fix (make intel_ips stop complaining unnecessarily) and 
one oops fix (unterminated list in dell-laptop). Both have been in -next 
for a while with no complaints.

The following changes since commit 4166fb64593514ad920b7dbd290e0a934b37d24a:

  Merge tag 'srpt-srq-type' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2012-04-12 18:51:32 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to d62d421b071b08249361044d8e56c8b5c3ed6aa7:

  dell-laptop: Terminate quirks list properly (2012-04-17 09:31:37 -0400)

----------------------------------------------------------------
Adam Jackson (1):
      intel_ips: Hush the i915 symbols message

Martin Nyhus (1):
      dell-laptop: Terminate quirks list properly

 drivers/platform/x86/dell-laptop.c |    1 +
 drivers/platform/x86/intel_ips.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
