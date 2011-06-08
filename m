Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1FHRH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:07:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55357 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1FHRH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:07:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, thomas@shipmail.org
Subject: [PATCH] bugfix and cleanup patches in the TTM code for 3.1.
Date: Wed,  8 Jun 2011 13:06:13 -0400
Message-Id: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DEFAC2B.0043:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug-fix "ttm: Do not increment the amount of pages in a pool by the current amount"
I never observed, but found while looking at the code. The cleanup patch:
"ttm: Fix spelling mistakes and remove unused #ifdef", I had posted earlier and Randy
Dunlap graciously added some extra cleanups - which I have rolled in.


