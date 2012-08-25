Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2HYT5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:57:15 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:2649 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2HYT5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:57:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="153817991"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/6] adjust inconsistent IS_ERR and PTR_ERR
Date: Sat, 25 Aug 2012 21:57:03 +0200
Message-Id: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where PTR_ERR does not access the value just tested
by IS_ERR.

