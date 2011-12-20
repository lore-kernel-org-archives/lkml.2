Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1LTIYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:24:32 -0500
Received: from linux-sh.org ([111.68.239.195]:46785 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab1LTIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:24:22 -0500
Date: Tue, 20 Dec 2011 17:24:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.2-rc7
Message-ID: <20111220082415.GA25648@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

        git://github.com/pmundt/linux-sh.git sh-fixes-for-linus

Which contains:

Yoshihiro Shimoda (1):
      sh: fix build warning in board-sh7757lcr

 arch/sh/boards/board-sh7757lcr.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)
