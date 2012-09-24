Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2IXNMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:12:55 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58897 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2IXNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:12:53 -0400
Date: Mon, 24 Sep 2012 06:12:49 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Zheng Yan <zheng.z.yan@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Current perf tool does not compile anymore on RHEL6
Message-ID: <20120924131249.GG22954@ghostprotocols.net>
References: <m2fw6fxmr7.fsf@firstfloor.org>
 <20120924102804.GC989@krava.brq.redhat.com>
 <20120924120529.GJ989@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924120529.GJ989@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 24, 2012 at 02:05:29PM +0200, Jiri Olsa escreveu:
> On Mon, Sep 24, 2012 at 12:28:04PM +0200, Jiri Olsa wrote:
> > On Tue, Sep 18, 2012 at 10:29:48AM -0700, Andi Kleen wrote:
> > > Presumably flex-2.5.35-8.el6.x86_64 doesn't support YY_EXTRA
> > > 
> > > Problem started with

> > > commit 90e2b22dee908c13df256140a0d6527e3e8ea3f4
> > > Author: Jiri Olsa <jolsa@redhat.com>
> > > Date:   Fri Jun 15 14:31:40 2012 +0800
> > > 
> > >     perf/tool: Add support to reuse event grammar to parse out terms

> > > Unfortunately needs several other patches reverted too to revert.
> > 
> > sry for late answer I was out last week,

> > it's strange since we build 6.3 perf on regular basis,
> > I'll check..
> 
> hm, it builds ok for me with:
> 
> # rpm -qa | egrep "(flex|bison)"
> flex-2.5.35-8.el6.x86_64
> bison-2.4.1-5.el6.x86_64
> 
> Do you still have the issue?

Possibly fixed by a patch by Eric Sandeen, see:

https://lkml.org/lkml/2012/9/20/691

- Arnaldo
