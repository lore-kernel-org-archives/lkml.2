Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab2CIUrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:47:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759347Ab2CIUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:47:28 -0500
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mtk.manpages@gmail.com
Cc: akpm@linux-foundation.org, xemul@parallels.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] prctl.2 and kcmp.2 updated
Date: Sat, 10 Mar 2012 00:47:20 +0400
Message-Id: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

here is a slightly updated version of patches for prctl (PR_SET_MM)
and kcmp syscall. Please review.

