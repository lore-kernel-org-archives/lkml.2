Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1ADX2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:28:00 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:49726
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010Ab1ADX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:27:59 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 0/3] Staging: rt2860: Fix checkpatch issues
Date: Wed,  5 Jan 2011 00:27:42 +0100
Message-Id: <1294183665-5995-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial checkpatch issues. 

L. Alberto Giménez (3):
  Staging: rt2860: Fix space after unary '*' operator.
  Staging: rt2860: Fix space after unary '*' operator.
  Staging: rt2860: Fix space after unary '*' operator.

 drivers/staging/rt2860/rt_linux.c |    3 +--
 drivers/staging/rt2860/rt_linux.h |   12 ++++++------
 drivers/staging/rt2860/wpa.h      |   12 ++++--------
 3 files changed, 11 insertions(+), 16 deletions(-)

-- 
1.7.2.3

