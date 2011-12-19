Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LSWbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:31:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55127 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1LSWbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:31:33 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
Subject: [PATCH v9 0/2] security: Yama LSM
Date: Mon, 19 Dec 2011 14:17:44 -0800
Message-Id: <1324333066-12452-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at the Linux Security Summit, I'm resubmitting this
code. As an LSM, it has coherent policy around expanding specific DAC
behaviors. There is no need for it to be a full-blown MAC, since it is
not intended to be one, but rather to be a simplified expansion to DAC,
with system-wide knobs. See the specific patches for details...

This version only contains the ptrace restrictions, since a path has
been cleared for that (thanks Roland). The link restriction discussion
can continue separately. In the meantime, I will carry it as a patch here:
http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/yama

Thanks,

-Kees

