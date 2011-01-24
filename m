Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1AXTgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:36:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36275 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1AXTgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:16 -0500
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org (open list)
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/4] Add missing IS_ERR test
Date: Mon, 24 Jan 2011 20:55:18 +0100
Message-Id: <1295898922-18822-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches perform various adjustments to error handling code related to
the possibility of an ERR_PTR value.

