Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2ATWfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:35:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab2ATWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:35:47 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        Cong Wang <xiyou.wangcong@gmail.com>, Li Wang <liwang@nudt.edu.cn>
Subject: eCryptfs: Truncate path improvements
Date: Fri, 20 Jan 2012 16:35:04 -0600
Message-Id: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Linus pointed out[1], eCryptfs needs more checks around its truncate path.
The first patch in this series makes it possible for an eCryptfs truncate
operation to be gracefully interrupted by a fatal signal. The second adds
checks for eCryptfs inode changes in setattr. The third is simply removal of
an old, unused function.

Tyler

[1] https://lkml.org/lkml/2012/1/18/356


