Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1BZXP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:15:57 -0500
Received: from cernmx30.cern.ch ([137.138.144.177]:46989 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1BZXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:15:56 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <julia@diku.dk>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/1] staging: vme: remove some more unreachable code
Date: Sun, 27 Feb 2011 00:15:34 +0100
Message-ID: <1298762135-8752-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some more unreachable code found in 
bridges/vme_ca91cx42.c and bridges/vme_tsi148.c.

Thanks,
Manohar Vanga

Manohar Vanga (1):
  staging: vme: remove unreachable code

 drivers/staging/vme/bridges/vme_ca91cx42.c |    3 ---
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

