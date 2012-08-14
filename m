Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2HNPty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:49:54 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:52609
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160Ab2HNPtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:49:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="153065910"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/5] Remove potential NULL dereference
Date: Tue, 14 Aug 2012 17:49:43 +0200
Message-Id: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches find a case where there is a dereference before a NULL test
and either move the dereference after the NULL test, or eliminate the NULL
test if it seems unnnecessary.

