Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2FFOSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:18:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44737 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2FFOSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:18:52 -0400
Message-ID: <4FCF66C8.2000208@gmail.com>
Date: Wed, 06 Jun 2012 08:18:48 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Darren Hart <dvhart@linux.intel.com>, Hitoshi Mitake <h.mitake@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michel Lespinasse <walken@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] perf bench: add new benchmark subsystem and suite "futex
 wait"
References: <1337268092-6765-1-git-send-email-h.mitake@gmail.com> <4FB52636.3040604@linux.intel.com> <CAMO-S2g9fkg_KH0CPOsB_7GQTN2mu8zir+UZDp6=VC+7XDrfrg@mail.gmail.com> <CAMO-S2gyzK3VTQcTRw+FAO9ui_gy=1z=MVxUYM9sPN51KrDgkg@mail.gmail.com> <4FCE4D24.5040307@linux.intel.com> <20120606073909.GI17808@gmail.com>
In-Reply-To: <20120606073909.GI17808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/12 1:39 AM, Ingo Molnar wrote:
> I'd rather not split it from the main perf binary, if embedded
> wants a small static binary (do they really?) we could add
> support for minimal builds of perf, with just a few [even one]
> subcommand activated or so.

Yes -- e.g., record and stat commands only.

David
