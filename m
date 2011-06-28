Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab1F1P6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:58:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36480 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab1F1P43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:56:29 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: [Patch 0/2] Fixes for masking of complain mode, and rcu protected ref
Date: Tue, 28 Jun 2011 16:56:03 +0100
Message-Id: <1309276565-20776-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of outstanding fixes to apparmor.

The following changes since commit b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git for-security

John Johansen (2):
      AppArmor: Fix reference to rcu protected pointer outside of rcu_read_lock
      AppArmor: Fix masking of capabilities in complain mode

 security/apparmor/domain.c |    2 +-
 security/apparmor/lsm.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

