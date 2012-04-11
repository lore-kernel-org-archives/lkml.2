Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab2DKSTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:19:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52205 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2DKSTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:19:20 -0400
Message-ID: <4F85CB23.8030305@gmail.com>
Date: Wed, 11 Apr 2012 12:19:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
References: <1334162178-17152-1-git-send-email-bp@amd64.org> <1334162178-17152-6-git-send-email-bp@amd64.org> <20120411180434.GH16257@infradead.org> <20120411180837.GJ16257@infradead.org>
In-Reply-To: <20120411180837.GJ16257@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/12 12:08 PM, Arnaldo Carvalho de Melo wrote:

>> [acme@sandy linux]$ make -j8 O=/home/git/build/perf tools/perf_install
>> [acme@sandy linux]$ ls -la tools/perf/*.o | wc -l
>> 22
>>
>> It should have honoured O=
>>
>> Can you fix this one please? :)
>
> But that can be on top of this series as the way I use it:
>
>    make -j8 -C tools/perf/ O=/home/git/build/perf install
>
> still works as expected.

Does this sequence still work?

cd tools/perf
make O=/tmp/pbuild

and the O= is honored?

David
