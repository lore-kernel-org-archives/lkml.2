Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935841Ab2C3W2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:28:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935626Ab2C3W1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:27:54 -0400
Date: Sat, 31 Mar 2012 00:18:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: john.stultz@linaro.org, jwboyer@redhat.com, lacombar@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig for v3.4-rc1
Message-ID: <20120330221807.GA28347@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kconfig bits for 3.4-rc1. There is one fix for make
oldconfig by Arnaud and updates to the merge_config.sh tool.

Thanks,
Michal

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

Arnaud Lacombe (1):
      kconfig: fix new choices being skipped upon config update

John Stultz (2):
      merge_config.sh: Set execute bit
      merge_config.sh: Add option to display redundant configs

Josh Boyer (1):
      merge_config.sh: Use the first file as the initial config

 scripts/kconfig/confdata.c      |   26 ++++++--------------------
 scripts/kconfig/merge_config.sh |   15 ++++++++++++++-
 scripts/kconfig/symbol.c        |    9 ++++++++-
 3 files changed, 28 insertions(+), 22 deletions(-)
 mode change 100644 => 100755 scripts/kconfig/merge_config.sh
