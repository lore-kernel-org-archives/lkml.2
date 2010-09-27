Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab0I0HkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:40:07 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31859 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab0I0HkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:40:06 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9EAML-02-2G3-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 09:39:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes
Message-ID: <20100927073958.GI13563@erda.amd.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
 <20100921103345.GT13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100921103345.GT13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull for tip/perf/urgent:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert

The following changes since commit 068e35eee9ef98eb4cab55181977e24995d273be:

  hw breakpoints: Fix pid namespace bug (2010-09-17 04:42:59 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Jiri Olsa (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 29

 arch/x86/oprofile/nmi_int.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

