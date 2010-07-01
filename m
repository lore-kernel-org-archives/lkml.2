Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0GATzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab0GATzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:55:06 -0400
Date: Thu, 1 Jul 2010 16:54:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf wrong branches event on AMD
Message-ID: <20100701195439.GJ4078@ghostprotocols.net>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 01, 2010 at 03:30:16PM -0400, Vince Weaver escreveu:
> Hello
> 
> while doing some performance counter validation tests on some assembly 
> language programs I noticed that the "branches:u" count was very wrong on 
> AMD machines.
> 
> It looks like the wrong event was selected.
> 
> This is why event selection needs to be in user-space... it could be fixed 
> instantly there, but the way things are done now it will take months to 
> years for this fix to filter down to those trying to use perf counters...

Well, you can use:

  rNNN (see 'perf list --help' on how to encode it) [Raw hardware event descriptor]

In the meantime.

- Arnaldo
