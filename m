Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1HDLeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:34:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1HDLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:34:13 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] regulator: tps65023: patch updates 
Date: Thu,  4 Aug 2011 13:33:48 +0200
Message-Id: <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently fighting with my email-client (Mark, sorry for the draft just sent), but this should be proper in both formatting and email-list.


Changes from previous patches:
 * Split up [PATCH 1/3] into two seperate patches ([PATCH [1-2]/4])
 * Declared tps_driver_data.info as const for avoiding awkward typecastings
 * Removed table-length structs and uses tps->table_len instead. (As Axel Lin suggested in lkml)


