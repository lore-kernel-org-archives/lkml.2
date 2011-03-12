Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1CLVHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:07:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44365 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755046Ab1CLVHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:07:45 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18xop1iSrwxlk2oWqxBsKMO/9EMBt+Bc0iZXf1Vlf
	r0fxCUvb9Yq3S7
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb cleanup patches
Date: Sat, 12 Mar 2011 21:22:55 +0000
Message-Id: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains random cleanups like removing unused or 
nearly unused variables, avoid artificial magic values as well as 
some common initialization cleanups.
Really no interesting stuff and nothing that is expected to
introduce regressions.


Best regards,

Florian Tobias Schandinat

