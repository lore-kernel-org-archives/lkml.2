Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0JKLJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:09:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36011 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab0JKLJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:09:35 -0400
Date: Mon, 11 Oct 2010 20:09:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 7/7] sh: oprofile: Use perf-events oprofile backend
Message-ID: <20101011110925.GB1155@linux-sh.org>
References: <cover.1286584677.git.matt@console-pimps.org> <a0c83396f5fb8a29baff3daf43d29b2e601511ff.1286584677.git.matt@console-pimps.org> <20101011110654.GR13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011110654.GR13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 01:06:54PM +0200, Robert Richter wrote:
> Matt and Paul,
> 
> are those (upper case) cpu_type strings already supported by the
> oprofile userland?
> 
I've only ever used out-of-tree patches with it due to the generally
volatile nature of support. Now that we have a more consistent interface
to go through, it probably makes sense to get those bits merged, too.
We're certainly not tied down to any ABI at this point.
