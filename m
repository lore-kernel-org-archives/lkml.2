Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2B0WXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:23:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2B0WXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:38 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [Patch 0/7] AppArmor: Add mediation of mount operations
Date: Mon, 27 Feb 2012 14:23:10 -0800
Message-Id: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For review:

The following patch series adds mount mediation to apparmor.  As part of
this it does some rework/cleanup up on the path name lookup and dfa matching
code, and adds base support for the extended policydb to policy loading.

This patch series assume the pull request containing Kees Cook's apparmorfs
patches have been applied.

