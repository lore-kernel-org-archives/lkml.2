Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1DXB5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:57:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55457 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757405Ab1DXB5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:57:15 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+RlUABbPiRHcF9wCO73RYSeUR6LIni0nTNpKCZyD
	8UNnryeTVg93ax
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb clock patches - third round
Date: Sun, 24 Apr 2011 02:13:18 +0000
Message-Id: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains basic support for the main IGP clock, 
avoids some double initialization and adds a compatiblity config 
option that ensures that you can still use a (non-fbdev) X server 
which could be otherwise confused by a disable clock/PLL due to the 
viafb power management.

All patches are also available at
	git://github.com/schandinat/linux-2.6.git viafb-pll

and will soon show up in linux-next.


Thanks,

Florian Tobias Schandinat

