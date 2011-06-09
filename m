Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1FIQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:40:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37098 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab1FIQkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:40:09 -0400
Date: Thu, 9 Jun 2011 16:40:04 +0000
From: Konrad Rzeszutek <konrad@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: [GIT PULL] (ibft-2.6) stable/broadcom.ibft-bugfixes for 3.0-rcX
Message-ID: <20110609164004.GA17186@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 16:40:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus

Please pull (now that I fixed the compile issue linux-next found):

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git stable/broadcom.ibft-bugfixes

which is based of v3.0-rc1 tag. It has a fix for a compile warning when
CONFIG_ACPI is not defined (and when CONFIG_ACPI was defined).

Connor Hansen (1):
      iscsi_ibft: iscsi_ibft_find unused variable i

 drivers/firmware/iscsi_ibft_find.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

