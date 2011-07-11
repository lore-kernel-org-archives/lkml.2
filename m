Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1GKDen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:34:43 -0400
Received: from linux-sh.org ([111.68.239.195]:50245 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987Ab1GKDem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:34:42 -0400
Date: Mon, 11 Jul 2011 12:34:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 10/11] sh/unicore32/irqs: Do not trace arch_local_{*,irq_*} functions
Message-ID: <20110711033418.GF24169@linux-sh.org>
References: <20110702030435.308336775@goodmis.org> <20110702033854.432833160@goodmis.org> <1309744599.2291.1.camel@epip-laptop> <1309870230.26417.171.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309870230.26417.171.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 08:50:30AM -0400, Steven Rostedt wrote:
> On Mon, 2011-07-04 at 09:56 +0800, Guan Xuetao wrote:
> > It looks good to me.
> > 
> > Thanks & Regards.
> > 
> 
> Thanks!
> 
> Are you or Paul going to pull it into the sh tree?
> 
I don't mind pulling it in, but it's probably easier to simply have it
lumped with the rest of the changes.
