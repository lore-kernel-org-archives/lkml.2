Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1CUWqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:46:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44069 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754011Ab1CUWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:46:01 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+h5B0PcoChzO9XDMV4ZURH7VYRxMwW/hMj2UDYT+
	YyHydtLHNkiY1O
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb fixes
Date: Mon, 21 Mar 2011 23:01:25 +0000
Message-Id: <1300748487-9883-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains two patches to fix handling of initial values 
selected via parameters. They are tested and confirmed to work on 
CLE266, VX800 and VX900.
They will show up in linux-next soon and are designated for 2.6.39, 
probably will go there at the end of the merge window or in an early 
release candidate.

Note:	These patches are minimal, further cleanup in this area is 
	planned for the next merge window.


Thanks,

Florian Tobias Schandinat

