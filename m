Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab2EWPVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:21:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39050 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab2EWPVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120523151612.GA8019@m.brq.redhat.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
	<1337585813-3349-1-git-send-email-jolsa@redhat.com>
	<CABPqkBTRzcuiwNAvpxt_N7AaddX9GAuGBS0+hWT78GiNqd-i2A@mail.gmail.com>
	<20120523151612.GA8019@m.brq.redhat.com>
Date: Wed, 23 May 2012 17:21:11 +0200
Message-ID: <CABPqkBRw_YALNuRfTOsmEqT7omtFJ1FLYVDip_nrdP=0qULCbw@mail.gmail.com>
Subject: Re: [RFC 0/5] perf, tool: uncore related changes
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: zheng.z.yan@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, ming.m.lin@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 5:16 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, May 23, 2012 at 04:53:13PM +0200, Stephane Eranian wrote:
>> Jiri,
>>
>> Is there a way with the current parser to have a syntax as follows:
>>
>>  perf stat -e cpu/event=cycles,edge/ ...
>>
>> In other words, avoid juggling between -e cycles and the -e
>> cpu/event=.../ syntax?
>
Also with this new syntax, how am I supposed to request precise sampling?

   perf stat -e cpu/event=cycles,edge,precise=1/

> I think it's possible.. so far we have the cpu/event=../ term in use for number
> assignment. We could do string translation to appropriate values.. I'll check
>
> added to my todo list ;)
>
> jirka
