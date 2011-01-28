Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1A1P1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:27:33 -0500
Received: from service87.mimecast.com ([94.185.240.25]:44280 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752063Ab1A1P1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:27:32 -0500
Subject: [GIT PULL] kmemleak fixes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Organization: ARM Limited
Date: Fri, 28 Jan 2011 15:27:19 +0000
Message-ID: <1296228439.1799.100.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 28 Jan 2011 15:27:26.0003 (UTC) FILETIME=[DDF63830:01CBBEFF]
X-MC-Unique: 111012815272713501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have two fixes for kmemleak. I would be grateful if you can merge them
(tested on both 2.6.37 and 2.6.38-rc2). Thanks.


The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git for-linus

Catalin Marinas (1):
      kmemleak: Allow kmemleak metadata allocations to fail

Jesper Juhl (1):
      kmemleak: remove memset by using kzalloc

 mm/kmemleak-test.c |    6 ++----
 mm/kmemleak.c      |   13 ++++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)



