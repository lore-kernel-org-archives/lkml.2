Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0K2NND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:13:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0K2NNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:13:01 -0500
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Updated perf offcore patchkit
Date: Mon, 29 Nov 2010 14:12:51 +0100
Message-Id: <1291036374-24710-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased on top of tip perf/perf-core with the new initcall sequence.
Now uses reference counts and kzalloc_node() to allocate the per node
data.
I dropped the patch that was already in tip.

-Andi

