Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2EPPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:32:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2EPPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:32:42 -0400
Message-ID: <4FB3C895.1050508@gmail.com>
Date: Wed, 16 May 2012 09:32:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf target: Add need_mmap field
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com> <1337161549-9870-3-git-send-email-namhyung.kim@lge.com> <20120516152831.GE7864@infradead.org>
In-Reply-To: <20120516152831.GE7864@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 9:28 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 16, 2012 at 06:45:49PM +0900, Namhyung Kim escreveu:
>> If perf doesn't mmap on event (like perf stat), it
>> should not create per-task-per-cpu events. So just
>> use a dummy cpu map to create a per-task event for
>> this case.
>
> Humm, perhaps target.no_mmap is better? I.e. just perf-stat would set
> it.
>

That gets back to the potential double negation Ingo frowns upon (!no_mmap).

David
