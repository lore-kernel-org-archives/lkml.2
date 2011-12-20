Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1LTXOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:14:44 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:34644 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1LTXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:14:42 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] cgroup: some cleanups of cgroup_attach_proc
Date: Tue, 20 Dec 2011 15:14:28 -0800
Message-Id: <1324422873-31001-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is a series of cleanups to cgroup_attach_proc. The
series will apply cleanly against cgroup/for-3.3.

There may be some collisions once Frederic's series is applied:

https://lkml.org/lkml/2011/12/20/260

So I may need to resend.

[1 V3] cgroup: remove redundate get/put of old css_set from migrate
[2] cgroup: remove redundant get/put of task struct
[3] cgroup: only need to check oldcgrp==newgrp once
[4] cgroup: remove extra calls to find_existing_css_set
[5] cgroup: separate out cgroup_attach_proc error handling code

Regards,
Mandeep
