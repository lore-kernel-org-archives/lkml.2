Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0G0Wjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:39:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0G0Wj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:39:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6056"; a="48987808"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org
Subject: [PATCH 0/4 -tip] delay documentation and checkpatch additions
Date: Tue, 27 Jul 2010 15:39:03 -0700
Message-Id: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset depends on:
commit 22b8f15c2f7130bb0386f548428df2ffd4e81903
Author: Patrick Pannuto <ppannuto@codeaurora.org>
Date:   Mon Jul 19 15:09:26 2010 -0700

    timer: Added usleep[_range] timer

on tip/master


The series first introduces some documentation explaining the various
linux delay mechanisms, and then adds some checkpatch rules to help
pick the most appropriate timer.

