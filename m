Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1HEVhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:37:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37322 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752166Ab1HEVhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:37:20 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19sFx9ZRR5sb/xIwybzzDPh7XsFFkSOI3lGX8gw3S
	NRBpb7sCa+jubk
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/6] viafb: remove superfluous register unlocking/locking
Date: Fri,  5 Aug 2011 21:55:54 +0000
Message-Id: <c174e3a3cd0594958c9afc6cdb8fbe20780d9c76.1312578946.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locking is done within the viafb_set_*_timing functions so there
is no need to do it here. Move a missing hardware reset into the
modesetting function.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

 drivers/video/via/hw.c              |    7 -------
 drivers/video/via/via_modesetting.c |    4 ++++
 2 files changed, 4 insertions(+), 7 deletions(-)
-- 
1.6.3.2

