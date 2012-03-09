Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab2CIVqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:46:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59021 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2CIVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:46:28 -0500
Message-Id: <20120309214102.240208363@openvz.org>
User-Agent: quilt/0.48-1
Date: Sat, 10 Mar 2012 01:41:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [patch 0/2] c/r update to prctl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series to extend prctl a bit for c/r needs.

 - new PR_SET_MM_EXE_FILE option to setup /proc/pid/exe
   symlink on restored program
 - new PR_GET_TID_ADDRESS option to retrieve process'
   clear_tid_address

Andrew, please drop Oleg's exe_path patch from -mm tree

 | The patch titled
 |    Subject: mm/exec: rename mm->exe_file to mm->exe_path
 | has been added to the -mm tree.  Its filename is
 |    mm-exec-rename-mm-exe_file-to-mm-exe_path.patch

This patch was deprecated.

	Cyrill
