Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2KBAQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:16:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47859 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762521Ab2KBAQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:16:22 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 0/4] arch/arm: support seccomp
Date: Thu,  1 Nov 2012 17:14:56 -0700
Message-Id: <1351815300-28627-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for seccomp BPF to ARM. When built with the seccomp
improvement patch waiting in linux-next ("seccomp: Make syscall skipping
and nr changes more consistent"), this passes the seccomp regression
test suite: https://github.com/redpig/seccomp

Thanks,

-Kees

---
v3:
 - updates suggested by Russell King:
   - reduced scope of expansion
   - leveraged TIF_SYSCALL_WORK bit mask
   - fixed syscall==-1 short-circuit logic
   
v2:
 - expanded ptrace_syscall_trace() into both callers and do
   secure_computing() hookup there, as requested by Al Viro.


