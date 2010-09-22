Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0IVFRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0IVFRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:17:52 -0400
From: cdahlin@redhat.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] inotify_add_watch_at
Date: Wed, 22 Sep 2010 01:16:55 -0400
Message-Id: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had use for this system call recently when I was trying to monitor a lockfile
to see when it disappeared. Its semantics are as you'd expect; it has over
inotify_add_watch what openat(2) has over open(2).

Currently compile-tested only, and missing hookups for arches I don't have
around.

--CJD

