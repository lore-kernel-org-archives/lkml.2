Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1AQWNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:13:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1AQWNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:13:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 2/4] ptrace: remove the extra wake_up_process() from ptrace_detach()
In-Reply-To: Tejun Heo's message of  Wednesday, 22 December 2010 12:13:16 +0100 <1293016398-18001-3-git-send-email-tj@kernel.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
	<1293016398-18001-3-git-send-email-tj@kernel.org>
X-Shopping-List: (1) Missing anonymous exhibitions
   (2) Dyspeptic sandwiches
   (3) Suspicious tedious nutrition seducers
   (4) Astigmatic rendezvous
Message-Id: <20110117221340.E6A4F180996@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 14:13:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course I agree that the current code is wrong here.  But I'm still not
at all clear on what practical compatibility problems it introduces.  This
change is OK if and only if we are really making the only area clean and
well-defined in the same release cycle.  It doesn't really matter that the
old behavior was ill-defined and unreliable in absolute terms, because the
practical userland experience of it in real-world cases is what userland
has grown to expect.  We can't break any such expectations until we have a
clear answer about how to solve the problems correctly.

Thanks,
Roland
