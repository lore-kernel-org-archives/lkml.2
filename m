Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2GLRsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:48:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2GLRst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:48:49 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Richard Fontana <fontana2012@gmail.com>
Cc: "Bradley M. Kuhn" <bkuhn@ebb.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 0/6] copyleft-next: project name / remove anti-tivoization clause
Date: Thu, 12 Jul 2012 10:48:39 -0700
Message-Id: <1342115325-9443-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

My last series of patches require a rebase based on the
latest changes, so patches 1-4 are a simple rebase.
Patch 5 and 6 address removing the anti-tivoization
clause, section 7. This will at the very least clarify
whether or not copyleft-next can or cannot be considered
as a licensing project with hopes of using it for the
Linux kernel.

Given copyleft-next's focus on separating from the
Church and in my views any possible 'corporate taint',
I'm in hopes that copyleft-next *can* consider the
Linux kernel community as a possible future and
valuable stakeholder.

Luis R. Rodriguez (6):
  copyleft-next: remove issue tracker references
  copyleft-next: more project name updates Copyleft.next->copyleft-next
  copyleft-next: rename the file COPYLEFT.next to copyleft-next
  copyleft-next: embrace the Signed-off-by practice
  copyleft-next: remove section 7 - Tivoization
  copyleft-next: re-enumerate sections

 ABOUT                          |   10 ++---
 CONTRIBUTING                   |   45 ++++++++++++++------
 COPYLEFT.next => copyleft-next |   90 ++++++++++------------------------------
 3 files changed, 60 insertions(+), 85 deletions(-)
 rename COPYLEFT.next => copyleft-next (82%)

-- 
1.7.10.rc1.22.gf5241

