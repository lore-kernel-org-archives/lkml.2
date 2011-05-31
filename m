Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1EaBqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 21:46:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50158 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab1EaBqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 21:46:04 -0400
Date: Mon, 30 May 2011 18:45:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Very high CPU load when idle with 3.0-rc1
Message-ID: <20110531014557.GV2668@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110530055924.GA9169@brouette>
 <1306755291.1200.2872.camel@twins>
 <20110530162354.GQ2668@linux.vnet.ibm.com>
 <1306773981.23844.2.camel@twins>
 <20110530212955.GT2668@linux.vnet.ibm.com>
 <1306791328.23844.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306791328.23844.13.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 11:35:28PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-05-30 at 14:29 -0700, Paul E. McKenney wrote:
> > But I should be able to move them back in under "if (cpu_online(cpu))",
> > right? 
> 
> Yeah, you should be able to put the wakeup in the spawn function when
> made conditional on cpu_online(), although I'm not quite sure how to do
> that for the rnp case, but I guess you'll have a better grasp on that.

OK, will give it a go.

							Thanx, Paul
