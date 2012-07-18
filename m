Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2GRMef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:34:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38288 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2GRMec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120718102152.GA2587@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <87fw9blyhj.fsf@sejong.aot.lge.com> <20120702101518.GC967@krava.redhat.com>
 <1341234662.1476.13.camel@leonhard> <20120702133341.GD967@krava.redhat.com>
 <CABPqkBTKNuwJXY7jRa+Zt8rmFftZUeJiYKEsKJeRiLdoHN3KWQ@mail.gmail.com>
 <CAOPLpQfWtyRHYT1ZfcdmshYoapBgF=FO7yFacYe8pyL0MBeebA@mail.gmail.com>
 <CABPqkBTTZaCVTtwJZbjXGwAihKAW_PMFK0+TZUTvbOn4pnfzvA@mail.gmail.com>
 <20120709110528.GA965@krava.redhat.com> <CABPqkBTGOvSuCfOUt=gnpfViVn8Whg0Mf7_3dUUim-iXA+8gjA@mail.gmail.com>
 <20120718102152.GA2587@krava.redhat.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 18 Jul 2012 08:34:10 -0400
Message-ID: <CAOPLpQcYiHP7oppUOQx8S5kmy15rKxA-bS=oO-3Ms-KYu3D9Bg@mail.gmail.com>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, Namhyung Kim <namhyung@gmail.com>,
        acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 6:21 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> Well, I personally like the '{}' syntax more than '--group-events or --group-reads
> option in front', it feels more user friendly.. anyway, we can easily have both ways.

I like the actual visual grouping better, too.

Also, it doesn't require us to define what

   -e E1,E2 --group-events -e E3,E4

means.  Does --group-events also apply to the first parameter?


> As for the group attributes and group leader sampling, I don't mind omitting
> them at this point and get back to that if we find it useful in future.

Just define the first event the leader.  What reason is there which
prevents this?


I can only second what Andi wrote: just get it done quickly.  This is
functionality that is desperately needed.
