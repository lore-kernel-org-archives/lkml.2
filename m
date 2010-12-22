Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0LVL2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:28:12 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:52056 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0LVL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=cImgD7Jfsqxyx1RHm75wlKTOe4LvmhWw5hlESz+ZgkPMNyqsVDCDeOPDDz/Veaddyg
         TQNjBFywhqGunbcMcWYGGke8SG6eLRzJ7ydTVCl9MCiiGXWAkqLonmYJgqcwdpIkDcAL
         GReGZ14jhEq+KME9kFI+l2zDmcevpiHRgGz28=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, jan.kratochvil@redhat.com
Subject: [PATCHSET] ptrace,signal: cleanups and fixes
Date: Wed, 22 Dec 2010 12:13:14 +0100
Message-Id: <1293016398-18001-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following four reviewed and updated patches
from the "ptrace,signal: sane interaction between ptrace and job
control signals, take#2"[1] patchset.

 0001-signal-fix-SIGCONT-notification-code.patch
 0002-ptrace-remove-the-extra-wake_up_process-from-ptrace_.patch
 0003-signal-remove-superflous-try_to_freeze-loop-in-do_si.patch
 0004-ptrace-kill-tracehook_notify_jctl.patch

The incorrect @why determination logic is dropped from 0004.

The git branch is located at,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-reviewed

Oleg, Roland, I'd like to base further patches on top of these, so
that we don't end up constantly reshuffling patches.  If there's a
better place to host the above patches, please feel free to pull the
branch or apply the patches.  Just let me know where to base further
patches.

Thank you.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1072474
