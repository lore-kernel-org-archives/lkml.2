Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab1CCR01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:26:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38848 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758539Ab1CCR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:26:26 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18GBaU3avMGNVhb21VJWvBKV1Gp0wkJyQ81xP3EVa
	AyRzgw1I0nyXZb
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: richard.cochran@omicron.at, johnstul@us.ibm.com, tglx@linutronix.de
Subject: some patches for the ptp framework 
Date: Thu,  3 Mar 2011 18:26:11 +0100
Message-Id: <1299173174-348-1-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patches 1 and 3 apply on top of tip:core/timer

patch 2 also requires Richards ptp v12 1/4 for the ptp class.
modulo a small conflict in drivers/ptp/Makefile and Kconfig.
because i had added his ixp driver, which the software clock is based on.

Richards Patchset didnt apply to tip:core/timer as is.
which branch is it based on ?

