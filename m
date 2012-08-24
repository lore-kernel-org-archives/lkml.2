Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2HXKFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:05:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59437 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756925Ab2HXKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:05:39 -0400
Date: Fri, 24 Aug 2012 11:05:05 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] kmemleak: replace list_for_each_continue_rcu with
 new interface
Message-ID: <20120824100505.GG7585@arm.com>
References: <502CB92F.2010700@linux.vnet.ibm.com>
 <502DC99E.4060408@linux.vnet.ibm.com>
 <5036D062.7070003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036D062.7070003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 01:52:50AM +0100, Michael Wang wrote:
> On 08/17/2012 12:33 PM, Michael Wang wrote:
> > From: Michael Wang <wangyun@linux.vnet.ibm.com>
> > 
> > This patch replaces list_for_each_continue_rcu() with
> > list_for_each_entry_continue_rcu() to save a few lines
> > of code and allow removing list_for_each_continue_rcu().
> 
> Could I get some comments on this patch?

Sorry, busy with other things and forgot about this.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
