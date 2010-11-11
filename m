Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0KKSDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:03:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:50426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab0KKSDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:03:19 -0500
From: Thomas Renninger <trenn@suse.de>
To: mingo@elte.hu
Cc: trenn@suse.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, jean.pihet@newoldbits.com
Subject: [RESEND] Power trace event cleanup by still providing old interface for some time
Date: Thu, 11 Nov 2010 19:03:12 +0100
Message-Id: <1289498595-25806-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have been discussed intensively on the trace/perf lists recently.
Outcome: cleanup power events in a (several kernel rounds) compatible way.

Ingo: As discussed, it would be great to see these in some tree/branch
soon as I'd like to base further cpu_idle cleanups/fixes on top.
Also Jean is waiting for these with further work/patches.

Thanks,

      Thomas

