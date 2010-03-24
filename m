Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0CXRfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:35:18 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46770 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0CXRfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=rd7UUOOFbUJRenICSN/ik+m/Rtrz9ox8RvPxerMo1RMLS9wwfhHirK8NCmzObjRnE7
         FgJfDfNHuJFUfpEA4dV/xRpnE8njYCizpDnQQuiJqkhIvDUSPv0mXlW/XiROYlKgTGJI
         jTTNFE9oUVLQY4E6tZihNcvZ6rYeRNTn2fh7k=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] [rt-kernel]
Date: Wed, 24 Mar 2010 18:35:05 +0100
Message-Id: <1269452107-28655-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are two trivial rt-kernel patches to fix up an unnecessary warning.

John Kacur (2):
  Revert "rt: trivial fix to REMINDER block in init/main.c"
  rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT

 init/main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

