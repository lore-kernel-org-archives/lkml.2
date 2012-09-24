Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2IXK2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab2IXK2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:28:12 -0400
Date: Mon, 24 Sep 2012 12:28:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, Zheng Yan <zheng.z.yan@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Current perf tool does not compile anymore on RHEL6
Message-ID: <20120924102804.GC989@krava.brq.redhat.com>
References: <m2fw6fxmr7.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2fw6fxmr7.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:29:48AM -0700, Andi Kleen wrote:
> 
> Presumably flex-2.5.35-8.el6.x86_64 doesn't support YY_EXTRA
> 
> Problem started with
> 
> commit 90e2b22dee908c13df256140a0d6527e3e8ea3f4
> Author: Jiri Olsa <jolsa@redhat.com>
> Date:   Fri Jun 15 14:31:40 2012 +0800
> 
>     perf/tool: Add support to reuse event grammar to parse out terms
> 
> 
> Unfortunately needs several other patches reverted too to revert.

sry for late answer I was out last week,

it's strange since we build 6.3 perf on regular basis,
I'll check..

jirka
