Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab1HRS7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:59:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49873 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HRS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:59:00 -0400
Date: Thu, 18 Aug 2011 19:58:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 00/91] pending uml patches
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My apologies for mailbomb from hell.  *All* this stuff is available in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-header.git/ #master,
but since uml folks had been stuck with mail and patch for a long time...

Anyway, most of the stuff in this pile is merging, cleaning and mutilating
subarchitecture-related code in arch/um.  By the end of it we have x86
bits largely merged between 32bit and 64bit variants and taken to arch/x86/um;
headers seriously cleaned up and mostly free of x86-isms now (not completely -
we still have page size dependencies in there).

Beginning of the series are pure build and driver fixes; those should go to
Linus before 3.1-final, IMO.

As far as I know, there's no regressions introduced by that pile; testing
and comments would be, of course, welcome.

