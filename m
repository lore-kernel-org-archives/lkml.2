Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2D0QFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:05:13 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:51614 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab2D0QFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:05:11 -0400
Message-ID: <4F9AC3B2.3080700@gmail.com>
Date: Fri, 27 Apr 2012 10:05:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com> <1335417327-11796-8-git-send-email-namhyung.kim@lge.com> <4F996433.7040003@gmail.com> <1335474778.1497.14.camel@leonhard> <4F99BCAF.1080309@gmail.com> <87397qhvvx.fsf@sejong.aot.lge.com> <20120427150821.GA27997@infradead.org> <4F9ABBF9.8080409@gmail.com> <20120427160040.GD27997@infradead.org>
In-Reply-To: <20120427160040.GD27997@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/12 10:00 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Apr 27, 2012 at 09:32:09AM -0600, David Ahern escreveu:
>> On 4/27/12 9:08 AM, Arnaldo Carvalho de Melo wrote:
>>> Ok, after this discussion, David, can I have your acked-by or tested-by?
>
>> I had reviewed the whole series yesterday, so you can add my
>
>> Reviewed-by: David Ahern<dsahern@gmail.com>
>
>> to the whole series if you want. I did not pull down the set and
>> apply to test it, and this particular patch requires prior ones so I
>> have not tested it.
>
> Fair enough, I'll add the Reviewed-by tag.
>
> I'm running 'perf test' after each patch. Doing it as root, but we need
> to automate this to do it as root, user, and user with each of the
> paranoid levels...
>
> - Arnaldo

Right - and that may include changing paranoid settings.

Also, the patchset is listed as RFC if that matters from running through 
all the formalities. One of the reasons I was not motivated to pull down 
the patches and apply/build/test.

David
