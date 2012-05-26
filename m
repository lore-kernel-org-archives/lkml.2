Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2EZMjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 08:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2EZMjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 08:39:31 -0400
Date: Sat, 26 May 2012 14:38:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120526123858.GA1679@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
 <20120525223646.GL27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525223646.GL27374@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:36:46AM +0200, Andi Kleen wrote:
> On Wed, Apr 04, 2012 at 11:16:08PM +0200, Jiri Olsa wrote:
> > hi,
> > adding support for creating event groups based on the way they
> > are specified on the command line. 
> 
> Any updates on this patchkit? We have a situation here where better 
> group management is needed to avoid problems with inconsistent
> counters that depend on each others.

The startup patches just got in recently
http://marc.info/?l=linux-kernel&m=133758460912306&w=2

so I'll continue on this shortly.. 

If you have some ideas on this or real world examples,
that would really help.. so far, here's the latest discussion:
http://marc.info/?t=133357436900005&r=1&w=2

and here's some thought on hows the display's going to look like:
http://marc.info/?l=linux-kernel&m=133458636513108&w=2


jirka
