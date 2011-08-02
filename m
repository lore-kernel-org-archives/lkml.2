Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1HBK7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:59:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38640 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1HBK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:59:47 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/4] regulator: tps65023: patch updates
Date: Tue,  2 Aug 2011 12:59:30 +0200
Message-Id: <1312282774-30880-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the tps65023 regulator patch set.

Changes from previous patches:
 * Split up [PATCH 1/3] into two seperate patches ([PATCHv2 [1-2]/4])
 * Declared tps_driver_data.info as const for avoiding awkward typecastings
 * Removed table-length structs and uses tps->table_len instead. (As Axel Lin suggested in lkml)

