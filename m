Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1G1Edh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 00:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab1G1Edd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 00:33:33 -0400
Date: Thu, 28 Jul 2011 00:33:27 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: broken checkpatch signature checking
Message-ID: <20110728043327.GA21448@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The signature checking patches in commit 2011247550 have broken one use-case for me.
I pipe the git-commits mailing list to it and skim the summary once a day[*]

Because git indents its changelogs, every single commit is now warning
with this..

WARNING: Do not use whitespace before Signed-off-by:
#5252:
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


	Dave


[*] It's too noisy to do anything useful with right now, which is
    why I'd like to filter out all the whitespace crap, but hopefully
    that'll happen eventually.
