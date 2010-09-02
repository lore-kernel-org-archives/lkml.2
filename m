Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0IBFCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:02:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59914 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0IBFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=QpwtL0Ji82QCZixxxqtAffrbqBMX6a1hUagKnN6urpirN+mauOD+aur1SABN0noG9p
         uh+A6+MifgJAL0h6deQBm81Pu6uM8wXvW8IZ54khmkyE4U2dSIKiLdYz/IPXg1IqGL/S
         m5dAS8ndJqYc5KCOPngQQRI5ya4fOLxSf4+G8=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 0/5] kprobes cleanups
Date: Thu,  2 Sep 2010 14:02:33 +0900
Message-Id: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a series of small fixups on kprobes.

Namhyung Kim (5):
  kprobes: remove redundant address check
  kprobes: verify jprobe entry point
  kprobes: make functions static
  kprobes: remove __dummy_buf
  kprobes: add sparse context annotations

 arch/x86/kernel/kprobes.c |   11 +++--------
 kernel/kprobes.c          |   22 ++++++++++++++--------
 2 files changed, 17 insertions(+), 16 deletions(-)

--
1.7.2.2

