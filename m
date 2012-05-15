Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab2EOBmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:42:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63162 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2EOBme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:42:34 -0400
Message-ID: <4FB1B486.4020509@gmail.com>
Date: Mon, 14 May 2012 19:42:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com> <87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com> <87k40e1cco.fsf@sejong.aot.lge.com>
In-Reply-To: <87k40e1cco.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/12 7:07 PM, Namhyung Kim wrote:
>> Something else is wrong then. I tested that command (saw your patch in
>> the history) and it worked for me. Also, this code path does not
>> affect perf-stat -- it touches perf-record and perf-test only.
>>
>
> Ah, right. But still wouldn't it be better changing the conditional
> rather than disabling it unconditionally?
>
> Thanks,
> Namhyung

I think it would be best to disable all events initially and then enable 
them when ready. It works for perf-record and perf-test just fine and 
limits the samples to what you care about.

David
