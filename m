Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2GBCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:25:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2GBCZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:25:26 -0400
Message-ID: <4FF10693.5000907@gmail.com>
Date: Sun, 01 Jul 2012 20:25:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri:

On 6/29/12 3:08 AM, Jiri Olsa wrote:
> hi,
> adding support for creating event groups based on the way they
> are specified on the command line.
>
> This patchset adds the '{}' style grammar to express event group,
> allowing so far only the 'event modifier' as group modifier.
>
> The sample/leader modifier changes are ready, but I'm getting
> some weird numbers in tests, so I'll send it later. Meanwhile,
> it'd be nice to have at least this patchset in.. ;)
>
>
> Attached patches:
>    1/3 perf, tool: Add support to parse event group syntax
>    2/3 perf, tool: Enable grouping logic for parsed events
>    3/3 perf, test: Add automated tests for event group parsing

Would you mind updating perf-stat and perf-record Documentation to 
include the group option?

David
