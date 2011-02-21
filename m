Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1BURhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:37:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54746 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753303Ab1BURho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:37:44 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+wb1NIfTywVxITMh5lfaF+s8yQ0Q1c9BUmTpAlK0
	U6Vkm2AO3wOFZI
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/5] fsnotify: decouple mark lock and marks fsobject lock
Date: Mon, 21 Feb 2011 18:33:24 +0100
Message-Id: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. mark lock
2. inode/vfsmount lock

With these patches only one of both locks are taken at the same time, which 
removes the need for a strict locking order.

These patches depend on patch "inotify: fix race when adding a new watch" sent to lkml
on Feb. 11.


