Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2CMNf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:35:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57872 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab2CMNf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:35:56 -0400
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 15:35:54 +0200
Message-ID: <CACVxJT_UWzpVo1Jfbf5Z2A-s16QjEv05MiNSY_EGihKTPuMyxg@mail.gmail.com>
Subject: seq_put_decimal_ull() et al
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject:    + procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch added to -mm tree

I think the fix is to create proper binary interface for exporting
interrupt counts.
Programs can parse raw data equally well if programming language is
even minimally reasonable
(POSIX shell may not qualify, though).
