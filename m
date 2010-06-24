Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0FXMSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:18:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0FXMSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:18:13 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624120226.GH578@basil.fritz.box>
References: <20100624102725.GA578@basil.fritz.box>
	 <1277375409.1875.943.camel@laptop> <20100624105254.GB578@basil.fritz.box>
	 <1277377121.1875.948.camel@laptop> <20100624110830.GC578@basil.fritz.box>
	 <1277377852.1875.950.camel@laptop> <20100624112040.GD578@basil.fritz.box>
	 <1277379204.1875.957.camel@laptop> <20100624115520.GF578@basil.fritz.box>
	 <1277380649.1875.962.camel@laptop>  <20100624120226.GH578@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 14:18:07 +0200
Message-ID: <1277381887.1875.966.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:02 +0200, Andi Kleen wrote:
> On Thu, Jun 24, 2010 at 01:57:29PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-06-24 at 13:55 +0200, Andi Kleen wrote:
> > > > but we don't have anything else that does that.
> > > 
> > > Actually we do, audit in syscalls and scheduling in interrupts and signals 
> > > all work this way. Probably more at some point adding more code to this
> > > path was very popular. 
> > 
> > That's the return to user path, nothing to do with softirqs. Add a TIF
> > flag and call your function there.
> 
> It does that, but there are some cases where it's not enough.

care to expand on that?
