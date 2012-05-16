Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab2EPCFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:05:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59981 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2EPCFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:05:11 -0400
Message-ID: <4FB30B52.7080104@gmail.com>
Date: Tue, 15 May 2012 20:05:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com
Subject: Re: [PATCH v2 0/5] perf tools: add meta-data header support in pipe
 mode
References: <1337081295-10303-1-git-send-email-eranian@google.com> <87ehqkewom.fsf@sejong.aot.lge.com>
In-Reply-To: <87ehqkewom.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/12 7:34 PM, Namhyung Kim wrote:
> Hi, Stephane
>
> On Tue, 15 May 2012 13:28:10 +0200, Stephane Eranian wrote:
>> This patch series adds meta-data support to perf record/report in pipe
>> mode:
>> 	perf record -o - foo | perf inject -b | perf report -i -
>>
>> We had meta-data (information about host configuration, perf tool version,...)
>> in regular (file) mode but it was lacking in pipe mode. This patch series fixes
>> this.
>>
>
> In addition to this change, I think it'd be great if we keep this
> meta-data somewhere for later use - I guess perf report and
> annotate on TUI, at least, will need it too. Just a suggestion :).
>
> Thanks,
> Namhyung
>

It is there -- see perf-report header. It gets dropped on pipe mode b/c 
the meta-data is in the header.

David
