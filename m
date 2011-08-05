Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab1HEVdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:33:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35576 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755651Ab1HEVds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:33:48 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19Le4RVYdhLB6oswFOqAonDWs+mnOOOfxN+7QaAWh
	odoCMA2F4LBUhc
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/6] viafb: use more compact modesetting functions
Date: Fri,  5 Aug 2011 21:52:15 +0000
Message-Id: <d60defb7b2c05b5c4b187171c09b714b0a00efe9.1312578946.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the old timing setup code with a redesigned one.
The new code might be slightly faster as it has no conditinals and
does not write the same register multiple times. Also it makes the
comparison to the documentation easier.
Regressions are unlikely but could happen as a lot of hardware is
undocumented.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

 drivers/video/via/hw.c              |  296 +----------------------------------
 drivers/video/via/hw.h              |  273 --------------------------------
 drivers/video/via/share.h           |   19 +--
 drivers/video/via/via_modesetting.c |  100 ++++++++++++
 drivers/video/via/via_modesetting.h |   18 ++
 5 files changed, 128 insertions(+), 578 deletions(-)
-- 
1.6.3.2

