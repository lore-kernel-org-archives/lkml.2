Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2EYNcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:32:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65420 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2EYNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:31:59 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:31:58 +0800
Message-ID: <CAJd=RBC58rzOybpsJJmryDRh0DeCC+cNR-rFuOfw0Y4tZqTzgw@mail.gmail.com>
Subject: [patch 0/4] BFS 420: fix ttwu
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes a few fixes related to ttwu.

[patch 1/4] BFS 420: fix ttwu_post_activation
	A helper fix for subsequent fixes

[patch 2/4] BFS 420: fix ttwu_stat
	Another helper fix

[patch 3/4] BFS 420: add task state check in ttwu
	Add task state check to avoid taking global runqueue lock

[patch 4/4] BFS 420: fix ttwu local
	With two helper fixes, ttwu_local is changed to be the same behavior
	with ttwu.


 kernel/sched/bfs.c		|   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)
