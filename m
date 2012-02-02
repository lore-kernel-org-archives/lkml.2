Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2BBOA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:00:57 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:33041 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab2BBOAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:00:55 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/3] Move call to PTR_ERR after reassignment
Date: Thu,  2 Feb 2012 15:00:44 +0100
Message-Id: <1328191247-23792-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where a location is reset to NULL before being
passed to PTR_ERR.

