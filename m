Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0KHHlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:41:23 -0500
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49045 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789Ab0KHHlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:41:21 -0500
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [REPOST, PATCH 0/3] dio: serialise unaligned direct IO
Date: Mon,  8 Nov 2010 18:40:20 +1100
Message-Id: <1289202023-15102-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repost of the last version of the series I wrote to prevent data corruption
cause by concurrent sub-block direct IO to the same block in the filesystem.
The problem still exists, the xfstest 240 is still triggering it, so we still
need to fix it.


