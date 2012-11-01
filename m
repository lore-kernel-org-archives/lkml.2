Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067Ab2KATsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:48:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48925 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964853Ab2KATsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:48:17 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 0/4] arch/arm: support seccomp
Date: Thu,  1 Nov 2012 12:46:35 -0700
Message-Id: <1351799199-6853-1-git-send-email-keescook@chromium.org>
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
v2:
 - expanded ptrace_syscall_trace() into both callers and do
   secure_computing() hookup there, as requested by Al Viro.

