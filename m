Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0IOBEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:04:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38459 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0IOBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vt5Wk3RAy2jaXKVPT9V+VCesNHyU6KV7PFqZu/fFuhRAjQ0k/W5dVEXHZ4zdrI2hj/
         BEv16CFkyExtYFH9Cfrw/O1Z4rXHqvvPEppBiq4QfQOyT3aZb6cqe2Tn1CHEw41YIMe6
         tjwmDk10PGUI50aeI/J5523KRg0o00vjJ2EQI=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 0/5] kprobes cleanups
Date: Wed, 15 Sep 2010 10:04:25 +0900
Message-Id: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a resend of my previous works on kprobes. All patches in this
series are small cleanups and got acked by Masami. Please consider
applying it.

Thanks.

---

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

