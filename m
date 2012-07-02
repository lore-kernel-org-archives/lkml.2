Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2GBUSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:18:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab2GBUSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:18:31 -0400
Message-ID: <1341260298.23484.21.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Improve basic Ivy Bridge support v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Date: Mon, 02 Jul 2012 22:18:18 +0200
In-Reply-To: <20120702195855.GH11413@one.firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
	 <1341254598-1379-2-git-send-email-andi@firstfloor.org>
	 <1341257194.23484.16.camel@twins>
	 <20120702195855.GH11413@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 21:58 +0200, Andi Kleen wrote:
> On Mon, Jul 02, 2012 at 09:26:34PM +0200, Peter Zijlstra wrote:
> > On Mon, 2012-07-02 at 11:43 -0700, Andi Kleen wrote:
> > > - As Stephane pointed out .code=0xb1, .umask=0x01 is gone from the
> > > event list,
> > > so don't do a generic backend stall event on IvyBridge. 
> > 
> > 325462-043US, May 2012:
> > 
> > Page 3135, Table 19-2. Non-Architectural Performance Events In the
> > Processor Core of Third Generation Intel Core i7, i5, i3 Processors
> 
> The table is outdated.
>
> But if you insist can readd it. It's just unlikely to work.

But you didn't state anything of the like. If anybody deviates from the
SDM they had better well bloody mention it. And you being from Intel, I
would very much like to have an Official (TM) statement right along with
it. Preferably in the form of a new SDM.

Also, you didn't CC Stephane, nor was it mentioned where this
observation was made from.

In short, the typical shoddy quality one expects from you.
