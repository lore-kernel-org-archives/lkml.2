Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0IQPct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:32:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45633 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab0IQPcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=R2Xw4rLRJo5Gsg9wh8JotTGJAWD3POcW+9uNsUW/RIV1OseUUM+lHgePmIiJiuk0IQ
         5hgxjtRWwrqrTGJDE2vIhu1cWUaGr5aw+QlbQyQ7RqtQcdsSBGFP+OLZP18ftrSoWZpV
         G56v+bQr9l1fDht2FwZ2EKDzYOb2HJa37pt+8=
Date: Fri, 17 Sep 2010 17:59:04 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 0/3 resend] x86: misc K8_NB updates
Message-ID: <20100917155904.GA4958@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches are against tip/master as of
v2.6.36-rc3-1233-gf3d0a67

Patch 1 sets the correct dependency to K8_NB for L3 cache index disable code
Patch 2 allows separate handling of gart and AMD northbridges
Patch 3 renames k8.[ch] and CONFIG_K8_NB to the more appropriate amd_nb.[ch] and CONFIG_AMD_NB

Please apply.


Thanks,

Andreas
