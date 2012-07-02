Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2GBUR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:17:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56772 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab2GBURy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:17:54 -0400
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
        Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Subject: [PATCH v2012.5 0/2] fs: add link restrictions
Date: Mon,  2 Jul 2012 13:17:12 -0700
Message-Id: <1341260234-32002-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the various issues that Al Viro pointed out[1], and is 
meant to be applied on top of the recent vfs tree, which changed how 
path_openat handles its error conditions[2].

Thanks,

-Kees

[1] https://lkml.org/lkml/2012/6/30/42
[2] http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=commitdiff;h=09dd2a0348dead8f8eaefe301f1f8cfd0473a4b2

