Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1L0OBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:01:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44208 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1L0OBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:01:39 -0500
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/6] use devm_request_and_ioremap
Date: Tue, 27 Dec 2011 15:01:25 +0100
Message-Id: <1324994491-21828-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 72f8c0bfa0de64c68ee59f40eb9b2683bffffbb0 added the function
devm_request_and_ioremap that combines devm_request_mem_region and
devm_ioremap or devm_ioremap_nocache.  Even if devm_request_and_ioremap
does not add functionality, except for the implicit choice between
devm_ioremap and devm_ioremap_nocache, it is much more concise than the
code it replaces.

There are a few more obvious opportunities for using
devm_request_and_ioremap if one is not picky about the name argument.

