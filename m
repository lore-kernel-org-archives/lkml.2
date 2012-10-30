Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2J3Av1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:51:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53462 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2J3Av0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:51:26 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>
Subject: [PATCH 0/4] arch/arm: support seccomp
Date: Mon, 29 Oct 2012 17:41:18 -0700
Message-Id: <1351557682-20983-1-git-send-email-keescook@chromium.org>
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

