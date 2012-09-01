Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2IAQdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 12:33:40 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:46619
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab2IAQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 12:33:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="154399775"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/4] drop frees of devm_ alloc'd data
Date: Sat,  1 Sep 2012 18:33:07 +0200
Message-Id: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop frees of devm_ alloc'd data.

