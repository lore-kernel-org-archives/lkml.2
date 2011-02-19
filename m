Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1BSWhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 17:37:23 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:36592 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752780Ab1BSWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 17:37:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBACfUX01Ld/sX/2dsb2JhbAAMhBTMT49igSeDQXYEhQ2MW4Yy
X-IronPort-AV: E=Sophos;i="4.62,193,1297054800"; 
   d="scan'208";a="92330708"
Message-ID: <4D604620.9060204@teksavvy.com>
Date: Sat, 19 Feb 2011 17:37:20 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit x86 system, 2.6.37 SMP kernel, Core2duo, 3.3GB RAM, no swap.

The system just suddenly switched to fbconsole and dumped a traceback.
Here's the screen-shot photo:  http://rtr.ca/ext4_crash.jpg

Is this a known bug that got fixed in 2.6.37.1 ?

Thanks
-ml
