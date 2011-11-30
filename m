Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1K3XD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:03:59 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39747 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab1K3XD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:03:56 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
Subject: [PATCH v7 0/2] security: Yama LSM
Date: Wed, 30 Nov 2011 15:01:36 -0800
Message-Id: <1322694098-21872-1-git-send-email-keescook@chromium.org>
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

