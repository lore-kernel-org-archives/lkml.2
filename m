Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0FNWVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:21:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0FNWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aGLNcJcTh3me1BPFcBjQdB5Retj4nwvKW+rQzVbpEPF9rJQRb0LyKeJiaYvVg+6GQ3
         uridcYXjNzkXFcsUPuqhvBhOWIJ7hYcaAF+wANWiofTyjJOOqIKQ2sASCzhPEhaMKici
         GqfIQuxXEVx1CmEofqaCmdbODcbnYAXJlEyBI=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/6] Potential rt patches for tip/rt/2.6.33
Date: Tue, 15 Jun 2010 00:21:21 +0200
Message-Id: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas:

This is a small collection of patches that I have in my -rt tree on-top
of 2.6.33.5-rt23

Please consider them for the next version of tip/rt/2.6.33

They can be pulled from
git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git tip-rt-2.6.33-jk

Amit Shah (1):
  hvc_console: Fix race between hvc_close and hvc_remove

Anton Blanchard (1):
  hvc_console: Fix race between hvc_close and hvc_remove

Arnaldo Carvalho de Melo (1):
  tracing: Update the comm field in the right variable in update_max_tr

John Kacur (1):
  lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.

Stephane Eranian (1):
  perf: Fix errors path in perf_output_begin()

Toshiyuki Okajima (1):
  KEYS: find_keyring_by_name() can gain access to a freed keyring

 drivers/char/hvc_console.c |   27 +++++++++++++++++----------
 kernel/lockdep_internals.h |    2 +-
 kernel/perf_event.c        |    2 +-
 kernel/trace/trace.c       |    4 ++--
 lib/Kconfig.debug          |   10 ++++++++++
 security/keys/keyring.c    |   18 +++++++++---------
 6 files changed, 40 insertions(+), 23 deletions(-)

