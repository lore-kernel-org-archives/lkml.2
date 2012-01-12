Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2ALVuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:50:00 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54324 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2ALVtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:49:36 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/4] adjust double test
Date: Thu, 12 Jan 2012 22:49:26 +0100
Message-Id: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where there are two tests of the same expression.

Please ignore the previous versions of these patches, which were sent by
accident.

