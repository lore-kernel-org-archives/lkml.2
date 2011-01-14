Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab1ANRJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:09:17 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:24205 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1ANRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:09:07 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHISME2rR7Ht/2dsb2JhbACkVnOiLphmhU8EhGuGK4Mi
Message-ID: <4D308331.6010106@cisco.com>
Date: Fri, 14 Jan 2011 10:09:05 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf timechart broken
References: <201101071104.37576.trenn@suse.de> <201101110955.37560.trenn@suse.de> <4D2CA7D6.2070203@cisco.com> <201101141800.18913.trenn@suse.de>
In-Reply-To: <201101141800.18913.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/14/11 10:00, Thomas Renninger wrote:
>> http://www.mail-archive.com/linux-perf-
> users@vger.kernel.org/msg00057.html
> Looks slightly different, the segfault should happen in:
> process_sample_event
> But looks very much related, possibly it has not been made/make with 
> DEBUG=1
> and -O6 was added and the backtrace is not 100% correct?

perf was built with DEBUG=1; that's how I got the pretty backtrace
versus having the arguments optimized out. The cpu=6291457 is the
garbage causing the segfault (there are only 2 cores in the system).
6291457 = 0x600001. Perhaps a mask is missing?

David

> 
> I still did not have time to send it out, will do so on Mo.
> 
>     Thomas
