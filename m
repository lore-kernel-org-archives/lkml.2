Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1HEVjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:39:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38310 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752299Ab1HEVja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:39:30 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19FY1lEL/JFr2T3xtu2aeQvFpyR2PxtNh4Fz3LmOY
	1xhbomHOgPviN7
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/6] viafb: remove superfluous mode lookup
Date: Fri,  5 Aug 2011 21:58:06 +0000
Message-Id: <9ee3ec49e268c7a01217d7865c53562fae1edf33.1312578946.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the result is not used anywhere there is no need to perform the
lookup at all.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

 drivers/video/via/viafbdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
-- 
1.6.3.2

