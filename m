Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2DYPwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:52:17 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50987 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2DYPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:52:15 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/3] AMD thresholding fixes
Date: Wed, 25 Apr 2012 17:52:00 +0200
Message-Id: <1335369123-23196-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

the following three patches fix MCE error thresholding issues on
upcoming F15h models.

Each commit message of the patch should contain more details.

If there are no issues, I'll add the queue to linux-next (I don't see a
branch from ras.git in linux-next, btw, which is strange).


Thanks.
