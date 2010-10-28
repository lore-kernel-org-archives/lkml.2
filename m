Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0J1WcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:32:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:40272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0J1WcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:32:18 -0400
Date: Fri, 29 Oct 2010 00:32:17 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: guillem@hadrons.org, nacc@us.ibm.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild packaging changes for 2.6.37-rc1
Message-ID: <20101028223217.GA4769@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please also pull these two fixes for make rpm-pkg and make deb-pkg,
respectively.

Thanks,
Michal

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git packaging

Guillem Jover (1):
      kbuild, deb-pkg: Check if KBUILD_IMAGE exists before copying it

Nishanth Aravamudan (1):
      scripts/package: don't break if %{_smp_mflags} isn't set

 scripts/package/builddeb |    4 +++-
 scripts/package/mkspec   |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)
