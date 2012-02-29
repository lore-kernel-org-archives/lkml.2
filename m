Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2B2MX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:23:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab2B2MX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:23:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.205.133.13 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Update man pages for prctl and kcmp syscall
Date: Wed, 29 Feb 2012 16:23:15 +0400
Message-Id: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a first draft to describe prctl extension and new
kcmp syscall. So I woule _really_ appreciate any feedback.

Cyrill

