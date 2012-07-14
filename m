Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2GNNAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:00:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab2GNNAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:00:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] cpufreq fix for 3.5-rc7
Date: Sat, 14 Jul 2012 15:06:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207141506.18345.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one cpufreq fix for 3.5-rc7 on top of commit
bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6

with commit hash c4686c71a9183f76e3ef59098da5c098748672f6

  cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git cpufreq-for-3.5-rc7

It fixes a regression that prevents the ACPI cpufreq driver from loading
on some systems where it previously worked without any problems.

Thanks!


 drivers/acpi/processor_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---------------

Thomas Renninger (1):
      cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression

