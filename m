Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0JLOPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:15:48 -0400
Received: from canuck.infradead.org ([134.117.69.58]:46497 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab0JLOPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:15:47 -0400
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <20101012135112.GE20436@basil.fritz.box>
References: <1286606987-19879-3-git-send-email-ying.huang@intel.com>
	 <1286813635.2336.617.camel@twins> <1286844650.7768.137.camel@yhuang-dev>
	 <1286863479.2336.1451.camel@twins> <1286864080.7768.179.camel@yhuang-dev>
	 <1286865071.2336.1478.camel@twins> <1286865447.7768.184.camel@yhuang-dev>
	 <1286865629.2336.1490.camel@twins> <1286865923.7768.188.camel@yhuang-dev>
	 <1286866193.2336.1503.camel@twins> <20101012135112.GE20436@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 16:15:27 +0200
Message-ID: <1286892927.29097.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 15:51 +0200, Andi Kleen wrote:
> > No, its not making sense, there's only one event source - the NMI, it
> > doesn't make any sense what so ever to then artificially split it in
> > two.
> 
> I can see that "unknown NMI" is a different kind of event than
> "NMI event triggered"
> 
> e.g. the debugger would only hook into "unknown NMI"

Sure, I'm not arguing about DIE_NMI vs DIE_NMI_UNKNOWN. I simply don't
see the point of DIE_NMI_IPI.


