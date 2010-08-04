Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893Ab0HDUib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934819Ab0HDUiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:38:16 -0400
Date: Wed, 4 Aug 2010 16:38:11 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: excessive wakeups in 2.6.35
Message-ID: <20100804203811.GA6479@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My laptop felt like it was about to burst into flames after I ran
2.6.35 on it for a while.  It actually got too hot to place on my legs.
Powertop showed it running over a 1000 wakeups a second while completely idle.

Chuck Ebbert pointed me at this diff..
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=396e894d289d69bacf5acd983c97cd6e21a14c08

which brings it back down to a much more respectable 80 wakeups a second.

Is this lined up for 2.6.35.1 ?

	Dave

