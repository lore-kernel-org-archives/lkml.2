Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1DQJ6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:58:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1DQJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:05 -0400
Message-Id: <20110417094505.865828233@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a rebase of an earlier series by Gautham.

  http://lkml.org/lkml/2009/5/11/203

I left out the second patch:

  http://lkml.org/lkml/2009/5/11/205

Because I couldn't reconstruct the thinking there, nor could I find
a good reason for it. Furthermore, I added a patch at the start that
implements a few extra locking self-tests.

This series wants testing and the self-tests really want to be extended
to cover more of the recursive read lock to gain confidence that all
does indeed work as intended.

I've also rewritten most of the changelogs to (hopefully) be better.



