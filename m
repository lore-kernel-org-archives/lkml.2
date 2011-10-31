Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676Ab1JaWlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:41:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36126 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:41:03 -0400
Date: Mon, 31 Oct 2011 15:40:57 -0700
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com
Subject: [PATCHSET UPDATED pm] freezer: fix various bugs and simplify
 implementation, take#2
Message-ID: <20111031224057.GG18855@google.com>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 31, 2011 at 12:05:11PM -0700, Tejun Heo wrote:
>  0001-freezer-fix-current-state-restoration-race-in-refrig.patch
>  0002-freezer-don-t-unnecessarily-set-PF_NOFREEZE-explicit.patch
>  0003-freezer-unexport-refrigerator-and-update-try_to_free.patch
>  0004-freezer-implement-and-use-kthread_freezable_should_s.patch
>  0005-freezer-rename-thaw_process-to-__thaw_task-and-simpl.patch
>  0006-freezer-remove-racy-clear_freeze_flag-and-set-PF_NOF.patch
>  0007-freezer-don-t-distinguish-nosig-tasks-on-thaw.patch
>  0008-freezer-use-dedicated-lock-instead-of-task_lock-memo.patch
>  0009-freezer-make-freezing-indicate-freeze-condition-in-e.patch
>  0010-freezer-test-freezable-conditions-while-holding-free.patch
>  0011-freezer-kill-PF_FREEZING.patch
>  0012-freezer-clean-up-freeze_processes-failure-path.patch
>  0013-cgroup_freezer-prepare-for-removal-of-TIF_FREEZE.patch
>  0014-freezer-make-freezing-test-freeze-conditions-in-effe.patch
>  0015-freezer-remove-now-unused-TIF_FREEZE.patch
>  0016-freezer-remove-should_send_signal-and-update-frozen.patch
>  0017-freezer-fix-set_freezable-_with_signal-race.patch

I completely forgot about the second patchset[1] fixing problems of
the first one.  The first two are folded into respective patches in
the series (0013 and 0014 updated).  The following three patches have
been appended to the series.

0018-freezer-restructure-__refrigerator.patch
0019-freezer-use-lock_task_sighand-in-fake_signal_wake_up.patch
0020-freezer-remove-unused-sig_only-from-freeze_task.patch

There still are three more patches which got lost.  I'll repost them
later.

The git branch has been updated to reflect the changes.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer

The new HEAD is efb69700c8 "freezer: remove unused @sig_only from
freeze_task()".

Thanks.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1187553
