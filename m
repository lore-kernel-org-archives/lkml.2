Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2HBQHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:07:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36700 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2HBQHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:07:04 -0400
Message-ID: <501AA5A2.2040800@gmail.com>
Date: Thu, 02 Aug 2012 10:06:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120723181358.GC6717@infradead.org> <500EAF23.8060909@gmail.com> <20120724161507.GG3732@erda.amd.com> <1343248546.26034.68.camel@twins> <20120726055011.GP26120@redhat.com>
In-Reply-To: <20120726055011.GP26120@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter:

On 7/25/12 11:50 PM, Gleb Natapov wrote:
> On Wed, Jul 25, 2012 at 10:35:46PM +0200, Peter Zijlstra wrote:
>> On Tue, 2012-07-24 at 18:15 +0200, Robert Richter wrote:
>>> thanks for this hint.
>>>
>>> On AMD cpus precise_ip maps to IBS, which does not support hardware
>>> options as perfctrs do. Thus, following attr flags are not supported:
>>>
>>>   exclude_user, exclude_kernel, exclude_host, exclude_guest
>>>
>>> Counting in guest mode is possible with IBS, but not the exclusion of
>>> a certain mode. If precise_ip counting is enabled on AMD we may not
>>> set the exclude_guest flag.
>>
>> IIRC we have SVM enter/exit hooks in kvm/perf already, we could use
>> those to implement exclude_guest for IBS.
>>
>> Now I've been trying to find the patches that introduced that, but I'm
>> failing horridly. Gleb, got us a pointer here?
> The commit is 144d31e6, but it introduces hook that is used on VMX only.
> SVM does not need it to implement guest/host only counters since it
> has HW support for that in the PMU.

Any updates?

David

