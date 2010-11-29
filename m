Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0K2Ah1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:37:27 -0500
Received: from bld-mail20.adl6.internode.on.net ([150.101.137.105]:47327 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754494Ab0K2AhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:37:19 -0500
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [PATCH 0/3] Use generic percpu counters in XFS
Date: Mon, 29 Nov 2010 11:36:38 +1100
Message-Id: <1290991002-18680-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series replaces the XFS per-cpu superblock counters with generic per-cpu
counters. It adds a specialised operation to the generic counter implementation
and then switches the XFS percpu superblock counters over to use the generic
percpu counter implementation. The result is several hundred lines of complex
code removed from XFS.

