Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab1FWWAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:00:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:51322 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1FWWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:00:12 -0400
Date: Thu, 23 Jun 2011 23:51:16 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH 00/37] Remove unneeded version.h includes (and add where
 needed).
Message-ID: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes up all reports of unneeded or missing 
linux/version.h includes reported by 'make versioncheck'.

I've manually inspected each file changed and also done build tests of 
'allnoconfig', 'allmodconfig' and 'allyesconfig' on x86-64 with these 
patches and have encountered no problems.

All patches are against Linus' tree as of a few hours ago and I've tried 
to split the series sensibly by subdirectory and/or maintainer.

Please consider applying them and let me know if there are any issues that 
need to be worked out.
All patches will be submitted as replies to this mail with additional 
relevant people Cc'ed on each specific patch.

Thank you in advance.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

