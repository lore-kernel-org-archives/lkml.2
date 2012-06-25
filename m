Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2FYTE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:04:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43875 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2FYTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:04:58 -0400
Message-ID: <4FE8B656.4080201@gmail.com>
Date: Mon, 25 Jun 2012 13:04:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, psuriset@linux.vnet.ibm.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf kvm: fix segfault with default guest arguments
References: <1340599286-89757-1-git-send-email-dsahern@gmail.com> <877guvwzt1.fsf@sejong.aot.lge.com> <4FE85EB6.80908@gmail.com>
In-Reply-To: <4FE85EB6.80908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/12 6:51 AM, David Ahern wrote:
> On 6/25/12 2:39 AM, Namhyung Kim wrote
>>
>> I don't know about the kvm, but isn't there a possibility that the same
>> thing happends on other types of event too - i.e. comm, fork, exit..?
>
> COMM, FORK, EXIT events cannot be generated in the guest of a guest;
> host machine is always non-NULL.

s/guest of a guest/context of a guest/

[That's I what get for rushing an email as I run out the door this morning.]

