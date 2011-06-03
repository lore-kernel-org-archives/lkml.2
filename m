Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1FCO50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:57:26 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:4396 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1FCO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:57:25 -0400
Subject: [PATCH 0/2] hpsa: fix a couple of minor bugs 
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Fri, 03 Jun 2011 09:57:24 -0500
Message-ID: <20110603145639.17254.54228.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a couple of minor bugs in the hpsa driver. 

---

Stephen M. Cameron (2):
      hpsa: fix dma unmap error in hpsa_passthru_ioctl
      hpsa: fix potential overrun while memcpy'ing sense data

-- 
-- steve
