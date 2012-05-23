Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab2EWPQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519Ab2EWPQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:16:36 -0400
Date: Wed, 23 May 2012 17:16:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: zheng.z.yan@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, ming.m.lin@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] perf, tool: uncore related changes
Message-ID: <20120523151612.GA8019@m.brq.redhat.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
 <1337585813-3349-1-git-send-email-jolsa@redhat.com>
 <CABPqkBTRzcuiwNAvpxt_N7AaddX9GAuGBS0+hWT78GiNqd-i2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTRzcuiwNAvpxt_N7AaddX9GAuGBS0+hWT78GiNqd-i2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 04:53:13PM +0200, Stephane Eranian wrote:
> Jiri,
> 
> Is there a way with the current parser to have a syntax as follows:
> 
>  perf stat -e cpu/event=cycles,edge/ ...
> 
> In other words, avoid juggling between -e cycles and the -e
> cpu/event=.../ syntax?

I think it's possible.. so far we have the cpu/event=../ term in use for number
assignment. We could do string translation to appropriate values.. I'll check

added to my todo list ;)

jirka
