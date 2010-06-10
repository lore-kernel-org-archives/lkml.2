Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab0FJPeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:34:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45074 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0FJPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:34:13 -0400
Date: Thu, 10 Jun 2010 17:34:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer
	with offstack cpumasks
Message-ID: <20100610153410.GD19561@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111046.18EB4B1A2B@basil.firstfloor.org> <1276181030.2077.399.camel@twins> <20100610145243.GC19561@basil.fritz.box> <1276181743.2077.426.camel@twins> <87fx0v3p1x.fsf@basil.nowhere.org> <1276183176.2077.484.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276183176.2077.484.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:19:36PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 17:06 +0200, Andi Kleen wrote:
> > +#if defined(CONFIG_CPUMASK_OFFSTACK) || defined(CONFIG_FAIR_GROUP_SCHED)
> 
> Still wrong.. something like the below might work, but I really think
> its not worth the trouble.

Yes it seems the ifdef maze in this function is too much for me.

Anyways I retract the patch, but you'll be reminded of it once
you update to gcc 4.6

-Andi
