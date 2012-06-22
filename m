Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086Ab2FVNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:09:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36632 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762054Ab2FVNJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:09:24 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86, UV: BAU additions and fixes
Cc: mingo@elte.hu, x86@kernel.org
Message-Id: <E1Si3c5-0008I6-CG@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 22 Jun 2012 08:09:25 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Following are 3 patches for use of SGI's Altix UV's Broadcast Assist Unit
for TLB shootdown.

[PATCH 1/3] x86: UV BAU destination timeout period
[PATCH 2/3] x86: UV BAU runtime enable and disable
[PATCH 3/3] x86: UV2 BAU hang workarounds

Number 3 is a large one.
All have been fully tested.
There is not an urgent need for them.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
