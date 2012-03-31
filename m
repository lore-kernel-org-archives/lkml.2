Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2CaVYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:24:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46321 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2CaVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAOPLpQdQFibpWg32D5GxtLkOkhao+c19z635cQxzMepKktD=oA@mail.gmail.com>
References: <4F718007.4000401@jp.fujitsu.com>
	<CAOPLpQdQFibpWg32D5GxtLkOkhao+c19z635cQxzMepKktD=oA@mail.gmail.com>
Date: Sun, 1 Apr 2012 06:24:41 +0900
Message-ID: <CABEgKgoSVUOSPr=xV_MY+=3XupYANfeLrPpNjn73w1gV127pSg@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年4月1日4:47 Ulrich Drepper <drepper@gmail.com>:
> 2012/3/27 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> Provides another format of /proc/stat for showing data in binary and
>> compress sequence of Zeros to some extent.
>>
>> Any other idea of formats ?
>
> Not for the format.  /proc/stat will likely not be the only file to be
> treated like this.  How abou an open() flag O_??? which indicates the
> binary format is wanted?  Maybe re-purpose a flag which doesn't have a
> meaning on those files (like, for instance, O_DIRECT).  Files which
> don't support the format can fail to open with the flag set.  This way
> all relevant files can be converted over time.

Sounds interesting. I'd like to think of that.

Thanks,
-Kame
