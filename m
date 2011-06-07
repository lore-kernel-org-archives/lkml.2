Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1FGAFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:05:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1FGAFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:05:24 -0400
Date: Tue, 7 Jun 2011 00:04:52 +0000
From: Konrad Rzeszutek <konrad@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: [GIT PULL] stable/broadcom.ibft-bugfixes for 3.0-rc2
Message-ID: <20110607000452.GA8607@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 00:04:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus

Please pull:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git stable/broadcom.ibft-bugfixes

which is based of v3.0-rc1 tag. It has a small time compile warning when
CONFIG_ACPI is not defined.

Connor Hansen (1):
      iscsi_ibft: iscsi_ibft_find unused variable i

 drivers/firmware/iscsi_ibft_find.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
