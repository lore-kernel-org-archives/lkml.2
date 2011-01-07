Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1AGQzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:55:43 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:39827 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1AGQzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:55:41 -0500
Subject: [PATCH 0/3] hpsa: A few more miscellaneous patches for Jan. 2011
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com,
        akpm@linux-foundation.org, smcameron@yahoo.com
Date: Fri, 07 Jan 2011 10:55:37 -0600
Message-ID: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series contains a few old fixes that I somehow failed
to send along previously.

---

Stephen M. Cameron (2):
      hpsa: fix use of uninitialized variable in hpsa_add_msa2xxx_enclosure_device()
      hpsa: Fix problem that CMD_UNABORTABLE command status was treated as unknown

Vasiliy Kulikov (1):
      hpsa: avoid leaking stack contents to userland


 drivers/scsi/hpsa.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

-- 
-- steve

