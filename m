Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2BIPra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:47:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38790 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2BIPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:47:29 -0500
Message-ID: <4F33EA8D.4050009@gmail.com>
Date: Thu, 09 Feb 2012 08:47:25 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data
 on a VM
References: <4F32A907.6030505@gmail.com> <20120208174434.GI22598@amd.com> <4F32B680.3090502@gmail.com> <20120208175709.GK22598@amd.com> <20120209073024.GA18010@elte.hu> <20120209111451.GM22598@amd.com> <20120209133446.GD8830@elte.hu> <20120209143253.GP22598@amd.com> <20120209152844.GQ22598@amd.com>
In-Reply-To: <20120209152844.GQ22598@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/2012 08:28 AM, Joerg Roedel wrote:
> On Thu, Feb 09, 2012 at 03:32:53PM +0100, Joerg Roedel wrote:
>> Yeah, right. Guest samples may also show up intentionally when the event
>> modifiers are used. So crashing on machine==NULL needs to be fixed.
> 
> Hmm, on the other hand, there is no way to specify guest symbol
> information to the regular perf subcommands except for perf-kvm. Without
> that information perf can not resolve any GUEST_KERNEL samples, so in
> the end there is no point in setting perf_guest to true except for
> perf-kvm, no?

Exactly. That was my point in my last reply.

