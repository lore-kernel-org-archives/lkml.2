Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1CXP5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:57:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55362 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754435Ab1CXP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:57:28 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+oKU1Ife+oker+z153huTBCPwOVAPLsdSJuB/suL
	ESreRBAIFqhhX+
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb clock patches - second round
Date: Thu, 24 Mar 2011 16:12:57 +0000
Message-Id: <1300983180-7343-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the remaining clock patches which finally put it in a good 
shape. Most of the clock and PLL went into an extra file making the 
codebase more structured. Only the PLL table and related code was 
left out as it is not yet in a desirable state as this table is only 
usable for the X1 source as the limits are frequency dependend.

All patches (including first round) are also available at
	git://github.com/schandinat/linux-2.6.git viafb-pll

and will also show up in linux-nexxt after the early rc's are done.


Thanks,

Florian Tobias Schandinat

