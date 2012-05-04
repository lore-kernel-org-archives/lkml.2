Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab2EDRkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:40:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46930 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2EDRkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:40:21 -0400
Message-ID: <4FA41481.7000704@gmail.com>
Date: Fri, 04 May 2012 11:40:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] perf, tool: Fix endian issues
References: <1336151493-8328-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1336151493-8328-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/12 11:11 AM, Jiri Olsa wrote:
> hi,
> sending fixies to properly handle perf.data endians.
>
> v2 changes:
>    - added patches 3 and 4 to handle sample_id_all header endianity
>
> Attached patches:
>    1/4 perf, tool: Handle different endians properly during symbol load
>    2/4 perf, tool: Carry perf_event_attr bitfield throught different endians
>    3/4 perf, tool: Handle endianity swap on sample_id_all header data
>    4/4 perf, tool: Fix 32 bit values endianity swap for sample_id_all header

Have you tested these patches by collecting data on PPC (or other big 
endian) and analyzing on Intel x86 and vice versa?

David

