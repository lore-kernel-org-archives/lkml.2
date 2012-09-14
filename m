Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2INF47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:56:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56617 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2INF44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:56:56 -0400
Date: Fri, 14 Sep 2012 07:56:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, alex.shi@intel.com, jbeulich@suse.com,
        tglx@linutronix.de, hpa@zytor.com
Subject: Re: [alex.shi@intel.com: Re: [PATCH] UV: fix incorrect tlb flush all
 issue]
Message-ID: <20120914055651.GE9043@gmail.com>
References: <20120913155310.GA4081@gmail.com>
 <20120913212003.GA16789@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913212003.GA16789@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> On Thu, Sep 13, 2012 at 05:53:10PM +0200, Ingo Molnar wrote:
> > 
> > Ack?
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Ack.
> But with the adjustment below.  The 'end' argument was not declared long.

Ok, great - mind sending the updated patch properly under a new 
title (the old one doesn't seem ideal), with an expanded 
changelog and with a Signed-off-by: Cliff Wickman, instead of 
the Acked-by?

Thanks,

	Ingo
