Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab2HJTHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:07:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab2HJTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:06:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 0/3] arm-soc updates
Date: Fri, 10 Aug 2012 21:06:12 +0200
Message-Id: <1344625575-27560-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:tmuTJxFE18PLzeVpfk4Lc5Zyhif+WSkXR7EbJ7kR6Gf
 vBOCj6Pq3gt1EkJh4TL2edRnUzN6RNLWdZyXScTee0bddemPu7
 jhUiEDxl9Pu4Ikj51PXXCNQehbKm1nzGNrBeCS8gHY3O7y2h0T
 VD33M6kWpPD/h2v8oBfmoquQqivfz9yTq5sRoESEHfa4zMW8CN
 4pjsZwpriPP00SAqVkMkuzMZminz3SdPqt9Apz91sx2cZ17RnE
 BL0iMRaIjvQKqoRpCy/w4dEP6Rv0TS5oo7zPoy3oIr4bYOmdJg
 q/Q8XF3D76mgotEbyUCujcNRSZByEIVRDOG2Xe+5/5bxl7dBQq
 5aYlrQ2PmTq3mFfDLqZq8NtJoMM7u87VhBMr5yTXS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are three pull requests for you to consider for the next -rc.

The first one is our regular bug fix series, this time with a lot
of patches fixing build regressions. Please pull at least this one.

The other two are things that fell through the cracks in the v3.6
merge window because of communication problems between the arm-soc
team and our downstream maintainers. Neither of them is important,
but applying them should also be harmless. If you feel like making
an exception, please have a look and consider merging them as well,
but don't worry about them otherwise.

	Arnd
