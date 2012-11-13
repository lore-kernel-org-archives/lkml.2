Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2KMSea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:34:30 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60632 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KMSe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:34:29 -0500
MIME-Version: 1.0
In-Reply-To: <50A1F0D6.7040403@gmail.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-3-git-send-email-yinghai@kernel.org>
	<50A1DFE1.3070809@jp.fujitsu.com>
	<CAE9FiQXx6p58T9B3df6waBUsywDd9NkZ5FsxMt5kjJ8hQmZqbw@mail.gmail.com>
	<50A1F0D6.7040403@gmail.com>
Date: Tue, 13 Nov 2012 10:34:27 -0800
X-Google-Sender-Auth: kAUXNgALbjw-2EdZ5rIc8S5WmuM
Message-ID: <CAE9FiQVZM9-TuBYZjWsqd58XqGW2tzQbwG3r6R9XfB+9D9_PKQ@mail.gmail.com>
Subject: Re: [PATCH 02/46] x86, mm: Split out split_mem_range from init_memory_mapping
From: Yinghai Lu <yinghai@kernel.org>
To: snakky.zhang@gmail.com
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:03 PM,  <snakky.zhang@gmail.com> wrote:
> On 2012年11月13日 14:20, Yinghai Lu wrote:
>>> 2012/11/13 6:17, Yinghai Lu wrote:
>>>>
>>>> +     nr_range = 0;
>>>
>>> This is unnecessary since it is set in the below.
>>>
>>>> +     nr_range = split_mem_range(mr, nr_range, start, end);
>>
>>                                                               ^^^^^^^^
>
> Why not use 0 directly?
>
> nr_range = split_mem_range(mr, 0, start, end);

yes, even could remove nr_range from split_mem_range.

but originally try to like "really" chopping the code to two parts.
