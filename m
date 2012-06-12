Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2FLTfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:35:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53778 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2FLTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:35:24 -0400
Date: Tue, 12 Jun 2012 21:35:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
Message-ID: <20120612193518.GC11413@one.firstfloor.org>
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com> <20120612190720.GA11137@aftab.osrc.amd.com> <1339529614.31548.104.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339529614.31548.104.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:33:34PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 21:07 +0200, Borislav Petkov wrote:
> > Nice, this is the initrd cpio thing, cool, no changes needed for the
> > bootloader. Ping me when you have something ready so that I can start
> > testing it here too. 
> 
> What do people like me do that don't use initrd like nonsense?

Use the patch kit I'm posting shortly...
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
