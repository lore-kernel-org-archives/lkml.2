Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0JSIze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:55:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:36158 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0JSIzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="618119761"
Subject: Re: [patch]x86: spread tlb flush vector between nodes
From: Shaohua Li <shaohua.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20101019084423.GB27723@elte.hu>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
	 <20101013081629.GA1621@basil.fritz.box>
	 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
	 <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>
	 <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>
	 <20101019084423.GB27723@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 16:55:32 +0800
Message-ID: <1287478532.9456.0.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 16:44 +0800, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Technically, it is way too late for anything new in this merge window, but we can 
> > try to make a reasonable assessment of the risk since the merge window got 
> > delayed.  However, this close to the merge window you cannot just expect to be 
> > merged even if the patch itself is OK.
> 
> a prompt re-send of the patch today-ish, with proper changelog, etc. and with the 
> new tuning in place is definitely a must.
the previous patch has changelog. what did you mean a new tuning?

