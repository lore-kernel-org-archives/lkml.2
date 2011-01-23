Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1AWAHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 19:07:32 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:38997
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750980Ab1AWAHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 19:07:31 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        trivial@kernel.org
Subject: [trivial][PATCH v2 0/3] Staging: rt2860: Fix spaces after unary '*' operator.
Date: Sun, 23 Jan 2011 01:07:17 +0100
Message-Id: <1295741240-11254-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.4.rc0.5.gf2665
In-Reply-To: <20110121201417.GA22299@kroah.com>
References: <20110121201417.GA22299@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial set of patches to fix coding style on the rt2860 staging driver, to
apply against Greg's staging-next tree.

L. Alberto Giménez (3):
  Staging: rt2860: rt_linux.c: Fix space after unary '*' operator.
  Staging: rt2860: rt_linux.h: Fix space after unary '*' operator.
  Staging: rt2860: wpa.h: Fix space after unary '*' operator.

 drivers/staging/rt2860/rt_linux.c |    3 +--
 drivers/staging/rt2860/rt_linux.h |   12 ++++++------
 drivers/staging/rt2860/wpa.h      |   12 ++++--------
 3 files changed, 11 insertions(+), 16 deletions(-)

-- 
1.7.4.rc0.5.gf2665

