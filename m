Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1E3VgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:36:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:45857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1E3VgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:36:14 -0400
Subject: Re: Very high CPU load when idle with 3.0-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110530212955.GT2668@linux.vnet.ibm.com>
References: <20110530055924.GA9169@brouette>
	 <1306755291.1200.2872.camel@twins>
	 <20110530162354.GQ2668@linux.vnet.ibm.com> <1306773981.23844.2.camel@twins>
	 <20110530212955.GT2668@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 May 2011 23:35:28 +0200
Message-ID: <1306791328.23844.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 14:29 -0700, Paul E. McKenney wrote:
> But I should be able to move them back in under "if (cpu_online(cpu))",
> right? 

Yeah, you should be able to put the wakeup in the spawn function when
made conditional on cpu_online(), although I'm not quite sure how to do
that for the rnp case, but I guess you'll have a better grasp on that.
