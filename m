Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2KMGUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:20:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63032 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2KMGUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:20:22 -0500
MIME-Version: 1.0
In-Reply-To: <50A1DFE1.3070809@jp.fujitsu.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-3-git-send-email-yinghai@kernel.org>
	<50A1DFE1.3070809@jp.fujitsu.com>
Date: Mon, 12 Nov 2012 22:20:20 -0800
X-Google-Sender-Auth: zstzkyn1lwCDogHnmdZLl7lQ788
Message-ID: <CAE9FiQXx6p58T9B3df6waBUsywDd9NkZ5FsxMt5kjJ8hQmZqbw@mail.gmail.com>
Subject: Re: [PATCH 02/46] x86, mm: Split out split_mem_range from init_memory_mapping
From: Yinghai Lu <yinghai@kernel.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 9:51 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> 2012/11/13 6:17, Yinghai Lu wrote:
>> +     nr_range = 0;
>
> This is unnecessary since it is set in the below.
>
>> +     nr_range = split_mem_range(mr, nr_range, start, end);
                                                             ^^^^^^^^
