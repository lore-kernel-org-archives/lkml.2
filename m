Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1CLVbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:31:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52809 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753587Ab1CLVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:31:09 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/Iv/wb9qzIR9PPquPCh22R6pC0bOI8KXdD9Q+ckF
	OFgdVmlnJKUMd2
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb clock/PLL patches
Date: Sat, 12 Mar 2011 21:46:22 +0000
Message-Id: <1299966386-3439-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains major changes in the way clocks are 
managed. A lot of duplicated and inaccurate values were removed and 
the behaviour for clocks without an exact match was improved. This 
causes some calculation overhead on each mode change but should 
allow easier extension and have always a behaviour that is at least
as good as the old one but is much saner for some clocks.

This will allow 
- easier adding of modes
- using generic mode tables
- easier adding of PLL configs
- generate PLL values on-the-fly
- use different clock sources


Best regards,

Florian Tobias Schandinat

