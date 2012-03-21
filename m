Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2CUPOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2CUPOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:14:00 -0400
Date: Wed, 21 Mar 2012 12:13:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120321151332.GD21163@infradead.org>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
 <1332269081.18960.444.camel@twins>
 <20120320204625.GA17142@gmail.com>
 <1332321311.18960.474.camel@twins>
 <20120321095211.GA11122@gmail.com>
 <1332330852.18960.482.camel@twins>
 <20120321121510.GA4386@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321121510.GA4386@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 21, 2012 at 01:15:10PM +0100, Ingo Molnar escreveu:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > I would much prefer a syntax that's more natural but requires 
> > quoting than one that's quirky and tailor made to avoid 
> > whatever current bash does. For one, there's other shells out 
> > there that might have different quoting needs and bash is of 
> > course free to extend its syntax.
> 
> Well, they are unlikely to extend to '+', it would break a 
> boatload of scripts I suspect.
> 
> So the question would be, is a+b+c as event grouping a natural 
> syntax? If not then lets use a quoted one that is.

   -e groupname=event1,event2,event3

Seems intuitive, no?

- Arnaldo
