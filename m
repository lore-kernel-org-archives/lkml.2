Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab1ESQ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:27:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:56965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab1ESQ1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:27:35 -0400
Date: Thu, 19 May 2011 16:25:53 +0000
From: Konrad Rzeszutek <konrad@hera.kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: michaelc@cs.wisc.edu, konrad@darnok.org
Subject: [GIT PULL] (ibft) stable/broadcom.ibft for 2.6.40
Message-ID: <20110519162553.GA1133@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 May 2011 16:25:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus

Please git pull:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git stable/broadcom.ibft

which is based of v2.6.37 (3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5) tag.

The branch has a bug-fix for the iBFT driver to work with out-of-spec
Broadcom drivers. They use the sign of 'BIFT' instead of the standard
'iBFT'.

diffstat:
 drivers/firmware/iscsi_ibft_find.c |   51 ++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 19 deletions(-)

and log:

Mike Christie (1):
      iscsi_ibft: search for broadcom specific ibft sign (v2)

