Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1ARCOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:14:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab1ARCOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:14:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED and TRACED
In-Reply-To: Tejun Heo's message of  Friday, 24 December 2010 15:00:50 +0100 <1293199257-11255-1-git-send-email-tj@kernel.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
X-Zippy-Says: ..I just walked into th' HOUSE OF REPRESENTATIVES with fourteen WET
    DOLPHINS and an out-of-date MARRIAGE MANUAL...
Message-Id: <20110118021417.D347A1807B7@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 18:14:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and for any kind of ptrace changes, please always run the whole
ptrace-tests suite before and after.  That is by no means an exhaustive
test that you haven't introduced new problems.  But if you introduce
regressions in that suite, it is quite like that you are causing problems
for existing ptrace users like gdb (even if some tests were racy before,
if the real-world practical results change, it could be a problem).

http://sourceware.org/systemtap/wiki/utrace/tests has the pointers.


Thanks,
Roland
