Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1CWWUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:20:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33274 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756731Ab1CWWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:20:00 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/8/tYUetD8VoDM9axNThKliEtX9BpM6PF/UIWj/R
	IVDUtwNo26xWHb
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: viafb clock patches - first round
Date: Wed, 23 Mar 2011 22:35:30 +0000
Message-Id: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These series contains a first batch of clock/PLL patches. There is 
still a lot to do (and a lot which can't be done due to missing 
documentation) but this should be enough to point in the direction 
we are heading. More PLL values have been allowed (in fact as much 
as can be done without complete documentation for each platform or 
using the knowledge Luc encoded in the Unichrome driver).
A bit restructuring was done to allow later moving the PLL/clock 
things to it's own file. Also code was added to manage PLL source 
and power but is not used yet as it is platform specific (I think) 
and we lack any useful abstraction for it at the moment. Some tests 
were performed to verify the documentation is not completly wrong.

All patches are also available at
	git://github.com/schandinat/linux-2.6.git viafb-pll

and will also show up in linux-next after the early rc's are done.


Thanks,

Florian Tobias Schandinat

