Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1D3OBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:01:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50543 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752102Ab1D3OBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:01:44 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+JzT4AXU+JnZFj0E/S4f4O5j/tx5+ulA4d5eI9rn
	r/3Bn2jogamMvz
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb misc patches
Date: Sat, 30 Apr 2011 14:18:03 +0000
Message-Id: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains various patches. One is a significant 
performance improvement for applications which use the framebuffer. 
Another one tries harder to make the framebuffer work by reducing 
the address space required for remapping, but as VIAs X server we 
still need a lot of parameters to be set correct to get a usable 
display. The last one is a little dead code removal.


Best regards,

Florian Tobias Schandinat

