Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2BZDXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 22:23:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37461 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2BZDXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 22:23:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of david.feuer@gmail.com designates 10.204.155.69 as permitted sender) smtp.mail=david.feuer@gmail.com; dkim=pass header.i=david.feuer@gmail.com
MIME-Version: 1.0
Date: Sat, 25 Feb 2012 22:23:13 -0500
Message-ID: <CAMgWh9uT-uUyruGZY-OboqR+mz4sv=FC0OMmCWhyH2QQBJdstA@mail.gmail.com>
Subject: 3.3.0-rc5 i915 drm crashes
From: David Feuer <david.feuer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The situation has improved since previous releases (fewer crashes, and
fewer non-recoverable crashes), but I'm still getting pretty bad drm
crashes off supertuxkart. What if any info should I send in to help
diagnose this problem?

David Feuer
