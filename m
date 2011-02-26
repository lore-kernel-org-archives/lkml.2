Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1BZWgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:36:40 -0500
Received: from cernmx32.cern.ch ([137.138.144.178]:16107 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1BZWgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:36:39 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <wfp5p@virginia.edu>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/1] staging: vme: remove unreachable code
Date: Sat, 26 Feb 2011 23:36:14 +0100
Message-ID: <1298759775-7822-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset gets rid of more unreachable code in vme.c. The removed 
lines are unreachable calls to kfree.

If there are any more that I didn't catch, please let me know.

Thanks,
Manohar Vanga

Manohar Vanga (1):
  staging: vme: remove unreachable code

 drivers/staging/vme/vme.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

