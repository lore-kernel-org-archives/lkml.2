Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2FNKpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:45:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54163 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2FNKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1339663013.2559.10.camel@twins>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	<1339420814-7379-3-git-send-email-jolsa@redhat.com>
	<CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	<20120613131240.GB2538@m.brq.redhat.com>
	<CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
	<1339594802.8980.44.camel@twins>
	<CABPqkBRnMW=Zmi+DycUPMcYS9cgs8doKZqSR37e1gU6wQnT+nw@mail.gmail.com>
	<1339663013.2559.10.camel@twins>
Date: Thu, 14 Jun 2012 12:45:15 +0200
Message-ID: <CABPqkBT54L=CuC_gJF3dnOOn6Tr1adVtedLOgzZQbmpZ5B-szA@mail.gmail.com>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:36 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-06-13 at 15:41 +0200, Stephane Eranian wrote:
>> Ok, yes that one. It would have been much nicer to follow the enum
>> order.
>
> Yes.. I should make a list of all the things we should've done
> differently. Maybe if that list grows long enough someone gets motivated
> enough to rev the format as a whole.
>
Yeah, that would be good.

I will soon post a patch to extend that format to make it possible to
have distinct sample_type per event and yet be able to parse them.
I am still waiting for Arnaldo to take my perf patches concerning pipe
mode first. Can't have too many patch sets in flight at the same time.

> It would be a tedious endeavour since you'd need to have both output
> paths available for a good while, but it might be worth it in the long
> run depending on how painful the current format becomes.

True. What we don't know however, it how many other tools are out
there using the kernel API directly.
