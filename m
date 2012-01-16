Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2APVP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:15:59 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754889Ab2APVP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:15:58 -0500
Date: Mon, 16 Jan 2012 15:16:17 -0600
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 0/6] x86, UV2: BAU fixes for UV version 2
Message-ID: <20120116211617.GD5512@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following are 6 patches for using SGI's Altix UV2's Broadcast Assist Unit
for TLB shootdown.

The first 3 patches are very necessary to using the BAU on this new
hardware.  Number 3 is a large one.

The last 3 are not so vital, but fairly trivial.
All have been fully tested.

[PATCH 1/6] x86, UV2: use native UV2 broadcast mode
  a new UV2 message format
[PATCH 2/6] x86, UV2: calc BAU destination timeout
  a fix for timeout calculation
[PATCH 3/6] x86: workaround for UV2 BAU bug
  workaround for a UV2 hardware bug
[PATCH 4/6] x86 UV2: remove no-resources test for UV2 BAU
  remove an unneeded test
[PATCH 5/6] x86, UV2: ack BAU interrupt earlier
  faster reaction to BAU interrupts
[PATCH 6/6] x86, UV2: accounting for BAU strong nacks
  add 3 new statistics

Signed-off-by: Cliff Wickman <cpw@sgi.com>
-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
