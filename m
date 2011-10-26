Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1JZVUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:20:52 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:27359 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1JZVUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:20:51 -0400
Subject: [PATCH 0/5] hpsa: driver updates, Oct 25, 2011
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mikem@beardog.cce.hp.com
Date: Wed, 26 Oct 2011 16:20:47 -0500
Message-ID: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements:

Scott Teel (2):
      hpsa: rename HPSA_MAX_SCSI_DEVS_PER_HBA
      hpsa: fix potential array overflow in hpsa_update_scsi_devices

Stephen M. Cameron (3):
      hpsa: set max sectors instead of taking the default
      hpsa: remove unused busy_initializing and busy_scanning
      hpsa: fix flush cache transfer length


 drivers/scsi/hpsa.c     |   37 ++++++++++++++++++++-----------------
 drivers/scsi/hpsa.h     |    5 +----
 drivers/scsi/hpsa_cmd.h |    5 ++++-
 3 files changed, 25 insertions(+), 22 deletions(-)

-- 
-- steve

