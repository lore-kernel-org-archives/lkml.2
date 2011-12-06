Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1LFTMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45409 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1LFTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:05 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [patch 00/24 ] dynamic debug enhancements: multi-queries during mod-init
Date: Tue,  6 Dec 2011 12:11:10 -0700
Message-Id: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0001-kernel-module.c-fix-compile-err-warnings-under-ifdef.patch
0002-dynamic_debug-fix-whitespace-complaints-from-scripts.patch
0003-dynamic_debug-drop-enabled-field-from-struct-_ddebug.patch
0004-dynamic_debug-make-dynamic-debug-supersede-DEBUG-ccf.patch
0005-dynamic_debug-change-verbosity-at-runtime.patch
0006-dynamic_debug-replace-strcpy-with-strlcpy-in-ddebug_.patch
0007-dynamic_debug-pr_err-call-should-not-depend-upon-ver.patch
0008-dynamic_debug-drop-explicit-NULL-checks.patch
0009-dynamic_debug-describe_flags-with-pmflt_.patch
0010-dynamic_debug-tighten-up-error-checking-on-debug-que.patch
0011-dynamic_debug-early-return-if-_ddebug-table-is-empty.patch
0012-dynamic_debug-reduce-lineno-field-to-a-saner-18-bits.patch
0013-dynamic_debug-chop-off-comments-in-ddebug_tokenize.patch
0014-dynamic_debug-enlarge-command-query-write-buffer.patch
0015-dynamic_debug-add-trim_prefix-to-provide-source-root.patch
0016-dynamic_debug-factor-vpr_info_dq-out-of-ddebug_parse.patch
0017-dynamic_debug-process-multiple-debug-queries-on-a-li.patch
0018-dynamic_debug-Introduce-global-fake-module-param-mod.patch
0019-pnp-if-CONFIG_DYNAMIC_DEBUG-use-pnp.dyndbg-instead-o.patch
0020-dynamic_debug-add-modname-arg-to-exec_query-callchai.patch
0021-kernel-module-replace-DEBUGP-with-pr_debug.patch
0022-dynamic_debug-protect-dyndbg-fake-module-param-name-.patch
0023-dynamic_debug-update-Documentation-kernel-parameters.patch
0024-dynamic_debug-remove-unneeded-includes.patch


