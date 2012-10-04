Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2JDUXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:23:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46759 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab2JDUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:23:06 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v5] module: add syscall to load module from fd
Date: Thu,  4 Oct 2012 13:22:30 -0700
Message-Id: <1349382154-9804-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a rebase onto Rusty's module-next tree. The syscall number
additions show the expected changes that are living in linux-next already,
just to avoid horrible collisions there.

I would _really_ like this to get into the 3.7 window, if possible. It's
gotten lots of support, and I think its cleanups actually improve the
readability of the module code.

This that be pulled from my tree:
git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tracking-modules-next-finit_module

Thanks,

-Kees

