Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1HEVkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:40:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49796 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751501Ab1HEVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:40:20 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/UawhQic3UxwYbIw+zqrsy3r/fjxqVyTHGOhOpHj
	hU4aEK17UrYZ3Q
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 5/6] viafb: simplify viafb_fill_crtc_timing
Date: Fri,  5 Aug 2011 21:58:55 +0000
Message-Id: <92746c3c82135b13d7fb1bbdebbabb0faedd8433.1312578946.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the first argument is just part of the structure passed as the
second argument there is no need for it at all.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

 drivers/video/via/dvi.c |    6 ++----
 drivers/video/via/hw.c  |   12 ++++++------
 drivers/video/via/hw.h  |    4 ++--
 3 files changed, 10 insertions(+), 12 deletions(-)
-- 
1.6.3.2

