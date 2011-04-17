Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1DQUFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:05:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44597 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1DQUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=jNSyntueQEp7554gYhk4n+TNdQNdHAnTeXj1Tda7ZBhSwCqKycAYa7pkIPIVO/6xhE
         ThJLIyCTvWoAeXD0K3N8bMwdPrWNB2DO09f3NJuMQuOh2VuZDzUCnnUl0+casCr+0Pnq
         bpEzv96CiFDKe0ypjplid8hGZKcg+XTmfZn/s=
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH 0/4][PULL] Alpha fixes
Date: Sun, 17 Apr 2011 13:05:22 -0700
Message-Id: <1303070726-32155-1-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are present in

  git://repo.or.cz/linux-2.6/rth.git for-linus

They fix compilation with gcc 4.6, a crash during bootup, and a
hang during bootup.


r~


Richard Henderson (4):
  alpha: Don't force -Werror.
  alpha: Remove set but unused variables.
  alpha: Fix RTC interrupt setup.
  alpha: Fix uninitialized value in read_persistent_clock.

 arch/alpha/kernel/Makefile       |    2 +-
 arch/alpha/kernel/core_mcpcia.c  |   12 +++++-------
 arch/alpha/kernel/err_titan.c    |    4 +---
 arch/alpha/kernel/irq_alpha.c    |    2 +-
 arch/alpha/kernel/setup.c        |    6 +++---
 arch/alpha/kernel/smc37c93x.c    |    3 +--
 arch/alpha/kernel/sys_wildfire.c |    5 +++--
 arch/alpha/kernel/time.c         |    1 +
 8 files changed, 16 insertions(+), 19 deletions(-)

-- 
1.7.4.2

