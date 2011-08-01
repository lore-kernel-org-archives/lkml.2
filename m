Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1HAMoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:44:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62002 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1HAMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:44:38 -0400
Message-ID: <4E369FB4.3070603@gmail.com>
Date: Mon, 01 Aug 2011 06:44:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <peterz@infradead.org>, anton@samba.org,
        acme@ghostprotocols.net, mingo@elte.hu, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: powerpc: Disable pagefaults during callchain stack
 read
References: <1312059200-11563-1-git-send-email-dsahern@gmail.com>	 <1312192792.2617.381.camel@laptop> <1312195147.8793.794.camel@pasglop>
In-Reply-To: <1312195147.8793.794.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/01/2011 04:39 AM, Benjamin Herrenschmidt wrote:
> On Mon, 2011-08-01 at 11:59 +0200, Peter Zijlstra wrote:
>>> Signed-off-by: David Ahern <dsahern@gmail.com>
>>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> CC: Anton Blanchard <anton@samba.org> 
>>
>> Hmm, Paul, didn't you fix something like this early on? Anyway, I've
>> no
>> objections since I'm really not familiar enough with the PPC side of
>> things. 
> 
> I'm travelling so I haven't had a chance to review properly or even test
> but it looks like an ad-hoc fix for the immediate problem.
> 
> Ultimately, I want to rework that stuff to do a __gup_fast like x86 does
> (maybe as a fallback from an attempt at access first) so we work around
> access permissions blocked by lack of dirty/accessed bits but in the
> meantime, this should fix the immediate issue.

The problem goes back to all kernel releases with perf, so this patch
should get applied to the stable trains too.

David

> 
> Cheers,
> Ben.
> 
> 
