Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2IRRi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:38:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55344 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2IRRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:38:55 -0400
Date: Tue, 18 Sep 2012 10:38:49 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, Zheng Yan <zheng.z.yan@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Current perf tool does not compile anymore on RHEL6
Message-ID: <20120918173849.GA6572@ghostprotocols.net>
References: <m2fw6fxmr7.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2fw6fxmr7.fsf@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 18, 2012 at 10:29:48AM -0700, Andi Kleen escreveu:
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

That is really, really strange, since I do work primarily on:

[acme@sandy linux]$ cat /etc/redhat-release 
Red Hat Enterprise Linux Server release 6.3 (Santiago)
[acme@sandy linux]$ rpm -q flex
flex-2.5.35-8.el6.x86_64

And haven't noticed such problem...

- Arnaldo
