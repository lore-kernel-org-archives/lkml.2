Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1FCOyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:54:14 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46493 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1FCOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:54:12 -0400
Subject: [PATCH 0/2] cciss: fix a couple minor bugs 
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 03 Jun 2011 09:54:10 -0500
Message-ID: <20110603145313.17174.78662.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fixes a couple of minor bugs in the cciss driver.

---

Stephen M. Cameron (2):
      cciss: Use the correct size when mapping in the config table
      cciss: fix potential overrun while memcpy'ing sense data

-- 
-- steve
