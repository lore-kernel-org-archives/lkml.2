Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab0JLNvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:51:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60597 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab0JLNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:51:15 -0400
Date: Tue, 12 Oct 2010 15:51:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
Message-ID: <20101012135112.GE20436@basil.fritz.box>
References: <1286606987-19879-3-git-send-email-ying.huang@intel.com>
 <1286813635.2336.617.camel@twins>
 <1286844650.7768.137.camel@yhuang-dev>
 <1286863479.2336.1451.camel@twins>
 <1286864080.7768.179.camel@yhuang-dev>
 <1286865071.2336.1478.camel@twins>
 <1286865447.7768.184.camel@yhuang-dev>
 <1286865629.2336.1490.camel@twins>
 <1286865923.7768.188.camel@yhuang-dev>
 <1286866193.2336.1503.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286866193.2336.1503.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, its not making sense, there's only one event source - the NMI, it
> doesn't make any sense what so ever to then artificially split it in
> two.

I can see that "unknown NMI" is a different kind of event than
"NMI event triggered"

e.g. the debugger would only hook into "unknown NMI"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
