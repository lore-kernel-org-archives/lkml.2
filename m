Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab0GBPBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:01:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:56694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab0GBPBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:01:04 -0400
Message-ID: <4C2DFEEA.9050704@kernel.org>
Date: Fri, 02 Jul 2010 16:59:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: tglx@linutronix.de
CC: mingo@elte.hu, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: [GIT PULL] irq: better lost/spurious irq handling
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Jul 2010 14:59:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

Please pull from the following branch to receieve lost-spurious-irq
patchset.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious-irq

The branch contains the patches to implement lost/spurious IRQ
handling (patches 0001-0010) and apply it to USB (0012).  libata part
is being discussed and not included in this pull request.

Thanks.

--
tejun

