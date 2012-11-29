Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2K2TJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:09:58 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:37059 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2K2TJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:09:56 -0500
Subject: [GIT PULL] target fixes for v3.7.0
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Nov 2012 11:09:45 -0800
Message-ID: <1354216185.25770.25.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

So just a single target fix for v3.7.0 this time around from Roland to
address a aborted command bug w/ tcm_qla2xxx fabric ports.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Also, there is one outstanding IBLOCK + virtio-blk bug that is still
being tracked down effecting v3.6.x, but AFAICT thus far this appears to
be a bug outside of target code.

Thank you,

--nab

Roland Dreier (1):
  target: Fix handling of aborted commands

 drivers/target/target_core_transport.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

