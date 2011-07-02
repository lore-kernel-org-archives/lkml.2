Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1GBVzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:35 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48208 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755229Ab1GBVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:28 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] [TRIVIAL] Cleanup spurious CONFIGs
Date: Sun,  3 Jul 2011 00:47:45 +0300
Message-Id: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I trust these are low-risk enough to be considered 'trivial'.
I noticed a recent typo correction patch to do with a CONFIG,
and immediately presumed that this could be a common type of
error, so went grepping. Many were found, but it wasn't obvious
what to do with all of them. These 7 seemed pretty easy to fix,
though.

Cheers,
Phil

