Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0I1Tbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:31:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48849 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0I1Tbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:31:43 -0400
MIME-Version: 1.0
Message-ID: <40229210-a2a6-41ab-9a88-bde956ebc66c@default>
Date: Tue, 28 Sep 2010 12:31:18 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: cleancache into linux-next, target for 2.6.37 merge window?
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi --

The "cleancache" patchset crosses multiple subsystem boundaries and
at the recent filesystem/storage/mm summit, people suggested that
after the patchset has stabilized, I should just submit it to
linux-next and then directly to Linus.  The latest version has received
no further suggestions or comments.  Previous versions received
a great deal of review and comment from a wide variety of maintainers
across all the impacted subsystems, as documented in the commit logs.

Would it be possible to include the following tree in the linux-next
build process?

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git#linux-next

The patchset applies cleanly against both 2.6.36-rc3 and -rc5.
Against next-20100928, I see two very minor merge conflicts in
mm/Kconfig and include/linux/fs.h due to minor changes from other
trees.

Thanks,
Dan Magenheimer
dan.magenheimer@oracle.com

