Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2GZA3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:29:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38422 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2GZA3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:29:50 -0400
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
Subject: [RESEND][PATCH v2012.5 0/2] fs: add link restrictions
Date: Wed, 25 Jul 2012 17:29:06 -0700
Message-Id: <1343262548-21743-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending; originally posted 2012-07-02: https://lkml.org/lkml/2012/7/2/394

This cleans up the various issues that Al Viro pointed out[1], and 
rebases to Linus's current tree.

Thanks,

-Kees

[1] https://lkml.org/lkml/2012/6/30/42

