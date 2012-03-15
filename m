Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954Ab2CODHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 23:07:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51082 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2CODHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 23:07:32 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: AppArmor v2 - Add the ability to mediate mount
Date: Wed, 14 Mar 2012 20:07:22 -0700
Message-Id: <1331780843-17195-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is v2 of the AppArmor mount rule extension.  It assumes the
previous pull requests have been applied.

Changes since v1.
- The variable initialization and other bugs pointed out in v1 have been fixed
- The mount matching of the different mount fns has been factored out into a
  common routine.
- Error reporting on the match has been improved to report where it fails
- a couple bugs in the matching of different elements have been fixed
  after further testing.
- Auditing and matching of the fs data element is now optional and is
  controlled by userspace rules indicating that a fs data match is required,
  and that auditing of such is desired.


