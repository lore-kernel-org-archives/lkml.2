Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1BNTQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:16:31 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:46790 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1BNTQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:16:29 -0500
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, ebiederm@xmission.com
Subject: [PATCH 0/3] procfs wrt pid namespace cleanups
Date: Mon, 14 Feb 2011 20:16:00 +0100
Message-Id: <1297710963-19843-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a cleanup and a preparation to unshare the pid
namespace. These prerequisite prepare the next Eric's patchset
to give a file descriptor to a namespace and join an existing
namespace.

The initial authors of this patchset are Eric Biederman and Oleg
Nesterov.

Changelog:

        02/14/11 - daniel.lezcano@free.fr
        * patch 2/3 : fix return ENOMEM and put_pid_ns on error
        * removed buggy patch #4 from the initial patchset

        01/31/11 - daniel.lezcano@free.fr:
        * patch 1/4 : wrapped test in a function
        * patch 2/4 : handle proc_pid_ns_prepare_proc error
        * patch 2/4 : put parent pid_ns on error
        * other patches : refreshed against linux-next


