Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2FYVGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:06:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59368 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2FYVGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:06:09 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>,
        Joe Korty <joe.korty@ccur.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v2012.4 0/2] fs: add link restrictions
Date: Mon, 25 Jun 2012 14:05:25 -0700
Message-Id: <1340658327-2932-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This splits the VFS restrictions from the audit reporting so they can
be reviewed separately. Note that this applies to linux-next (in that
the error/filp handling in namei.c changed[1]).

-Kees

[1] https://lkml.org/lkml/2012/6/25/312

