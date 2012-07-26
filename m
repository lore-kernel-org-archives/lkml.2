Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2GZWDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:03:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2GZWDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:03:07 -0400
Message-ID: <1343340164.32120.21.camel@twins>
Subject: Re: [ 028/108] sched/nohz: Rewrite and fix load-avg computation --
 again
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jul 2012 00:02:44 +0200
In-Reply-To: <20120726220107.GG1894@decadent.org.uk>
References: <20120723010655.768372060@decadent.org.uk>
	 <1343138818.5132.98.camel@deadeye.wl.decadent.org.uk>
	 <1343337937.32120.20.camel@twins> <20120726220107.GG1894@decadent.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 23:01 +0100, Ben Hutchings wrote:
> 
> That's what I thought, so I went ahead with just the one.
> Should I queue up the other two for a future 3.2.y update? 

Yeah, why not.. 
