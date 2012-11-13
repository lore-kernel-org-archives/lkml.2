Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab2KMHEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:04:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2KMHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:03:59 -0500
Message-ID: <50A1F0D6.7040403@gmail.com>
Date: Tue, 13 Nov 2012 15:03:50 +0800
From: snakky.zhang@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/46] x86, mm: Split out split_mem_range from init_memory_mapping
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-3-git-send-email-yinghai@kernel.org> <50A1DFE1.3070809@jp.fujitsu.com> <CAE9FiQXx6p58T9B3df6waBUsywDd9NkZ5FsxMt5kjJ8hQmZqbw@mail.gmail.com>
In-Reply-To: <CAE9FiQXx6p58T9B3df6waBUsywDd9NkZ5FsxMt5kjJ8hQmZqbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年11月13日 14:20, Yinghai Lu wrote:
> On Mon, Nov 12, 2012 at 9:51 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> 2012/11/13 6:17, Yinghai Lu wrote:
>>> +     nr_range = 0;
>> This is unnecessary since it is set in the below.
>>
>>> +     nr_range = split_mem_range(mr, nr_range, start, end);
>                                                               ^^^^^^^^
Why not use 0 directly?

nr_range = split_mem_range(mr, 0, start, end);



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

