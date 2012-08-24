Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab2HXTyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:54:21 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56031 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132Ab2HXTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:54:17 -0400
Date: Fri, 24 Aug 2012 12:53:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/3] kmemleak: replace list_for_each_continue_rcu with
 new interface
Message-ID: <20120824195357.GR2472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <502CB92F.2010700@linux.vnet.ibm.com>
 <502DC99E.4060408@linux.vnet.ibm.com>
 <5036D062.7070003@linux.vnet.ibm.com>
 <20120824100505.GG7585@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824100505.GG7585@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082419-5518-0000-0000-00000718639C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:05:05AM +0100, Catalin Marinas wrote:
> On Fri, Aug 24, 2012 at 01:52:50AM +0100, Michael Wang wrote:
> > On 08/17/2012 12:33 PM, Michael Wang wrote:
> > > From: Michael Wang <wangyun@linux.vnet.ibm.com>
> > > 
> > > This patch replaces list_for_each_continue_rcu() with
> > > list_for_each_entry_continue_rcu() to save a few lines
> > > of code and allow removing list_for_each_continue_rcu().
> > 
> > Could I get some comments on this patch?
> 
> Sorry, busy with other things and forgot about this.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Queued, thank you both!

							Thanx, Paul

