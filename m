Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2L0Kr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 05:47:58 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:46126 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2L0Krz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 05:47:55 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
CC: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RESEND PATCH] modpost: For ARC Port submission
Date: Thu, 27 Dec 2012 16:17:19 +0530
Message-ID: <1356605240-4555-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-21-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-21-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is following up on ARC Linux Port submission bits:
Basic Port: https://lkml.org/lkml/2012/11/7/114
Addons:     https://lkml.org/lkml/2012/11/12/121

I'm resending this single patch to hopefully get ACK on simple modpost change.

Thx,
-Vineet

Vineet Gupta (1):
  modpost: Ignore ARC specific non-alloc sections

 scripts/mod/modpost.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

-- 
1.7.4.1

