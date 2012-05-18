Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab2ERQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:50:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57095 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab2ERQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:50:51 -0400
Message-ID: <4FB67DE5.8050000@gmail.com>
Date: Fri, 18 May 2012 10:50:45 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, acme@redhat.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
References: <1337081295-10303-1-git-send-email-eranian@google.com> <1337081295-10303-5-git-send-email-eranian@google.com> <4FB32032.3000509@gmail.com> <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
In-Reply-To: <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 1:41 AM, Stephane Eranian wrote:
> On Wed, May 16, 2012 at 5:34 AM, David Ahern<dsahern@gmail.com>  wrote:
>> I love the feature and it works nicely, but there has been push back on
>> adding more synthesized events.  Also the size of the patch is a bit much to
>> take in. If there is no objection to the synthesized can you break the patch
>> up -- e.g., introduce the events in one, synthesis and processing functions
>> in another, plug into the commands, ...
>>
> Without new synthesized events, you cannot make this work. This is by
> construction
> of the pipe mode. Meta-data has be be injected in the stream and
> therefore it needs
> PERF_RECORD_* types.

Understood. I don't object to synthesized events.

Arnaldo: preferences?

David
