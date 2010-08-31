Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0HaPsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:48:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44541 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab0HaPsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:48:46 -0400
From: Julia Lawall <julia@diku.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/4] Add of_node_put to avoid memory leak
Date: Tue, 31 Aug 2010 17:48:54 +0200
Message-Id: <1283269738-14612-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce calls to of_node_put after various functions that
call of_node_get.

