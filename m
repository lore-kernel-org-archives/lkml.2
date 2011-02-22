Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1BVPrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:47:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab1BVPrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:47:02 -0500
Subject: Re: [PATCH 3/6] Add support to the perf tool to specify extra
 values for raw events and pass them to the kernel.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110220211740.GU5818@one.firstfloor.org>
References: <1298221040.2318.68.camel@localhost>
	 <20110220211740.GU5818@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Feb 2011 16:46:49 +0100
Message-ID: <1298389609.2217.250.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 22:17 +0100, Andi Kleen wrote:
> On Mon, Feb 21, 2011 at 12:57:20AM +0800, Lin Ming wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The new format is -e rXXXX[,YYYY]
> 
> Need to switch to a different character than , as separate -- 
> it's already used for multiple events. Perhaps :

Yeah, I've contemplated writing a proper syntax and parser generator for
all this, its starting to become somewhat of a mess.

Its just that I've since forgotten everything I ever knew about
lex/yacc/bison etc.


