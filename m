Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2K1Chh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:37:37 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54920 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763Ab2K1Chg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:37:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 0/3] staging/fwserial: teardown cleanup
Date: Tue, 27 Nov 2012 21:37:10 -0500
Message-Id: <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20121127170407.GC2687@kroah.com>
References: <20121127170407.GC2687@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch series fixes up staging/fwserial to meet the new requirements
in Jiri Slaby's series "TTY: memory leaks patchset" (in tty-next).

Strictly speaking, only PATCH 1/3 implements the necessary cleanup.
PATCHES 2/3 & 3/3 are additional cleanups in the same area.

Peter Hurley (3):
  staging/fwserial: Destruct embedded tty_port on teardown
  staging/fwserial: Use WARN_ONCE when port table is corrupted
  staging/fwserial: Remove superfluous free

 drivers/staging/fwserial/fwserial.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

-- 
1.8.0

