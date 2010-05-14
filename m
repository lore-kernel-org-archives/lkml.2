Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0ENSfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:35:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62757 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0ENSfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:35:23 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [GIT PULL] one more davinci fix for 2.6.34
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 11:35:19 -0700
Message-ID: <87wrv6ib6g.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull one last one-liner fix for the DaVinci platform for 2.6.34.

Thanks,

Kevin


The following changes since commit b57f95a38233a2e73b679bea4a5453a1cc2a1cc9:
  Linus Torvalds (1):
        Linux 2.6.34-rc7

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-fixes-for-linus-2

Sergei Shtylyov (1):
      DA830: fix USB 2.0 clock entry

 arch/arm/mach-davinci/da830.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
