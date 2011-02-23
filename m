Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1BWNZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:25:45 -0500
Received: from cernmx30.cern.ch ([137.138.144.177]:30070 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1BWNZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:25:44 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <wfp5p@virginia.edu>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/2] staging: vme: fix issues in vme_register_bridge
Date: Wed, 23 Feb 2011 14:25:26 +0100
Message-ID: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes two issues I found in vme_register_bridge. 
The first gets rid of some unreachable code and the second one fixes 
a bug that could potentially lead to an infinite loop in the event
that device_register fails.

Please skip the previous patchset I sent and reacknowledge these.
Apologies for the noise pollution.

Thanks,
Manohar Vanga

Manohar Vanga (2):
  staging: vme: remove unreachable code
  staging: vme: fix loop condition

 drivers/staging/vme/vme.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

