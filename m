Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2JVUu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:50:58 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:1604 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab2JVUu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:50:56 -0400
Message-ID: <5085B1A8.4020609@parallels.com>
Date: Tue, 23 Oct 2012 00:50:48 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
References: <20121022191452.785366817@openvz.org> <20121022122934.d2e2fa57.akpm@linux-foundation.org>
In-Reply-To: <20121022122934.d2e2fa57.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 11:29 PM, Andrew Morton wrote:
> On Mon, 22 Oct 2012 23:14:52 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> Hi guys, during c/r sessions we've found that there is no way at
>> the moment to fetch some VMA associated flags, such as mlock()
>> and madvise(), thus the patches in this series intorduce new field
>> into "smaps" output called VmFlags where all flags associated with
>> the particular VMA is shown in two letter mnemonic.
>>
>> Strictly speaking for c/r we only need mlock/madvise bits but it
>> has been said that providing just a few flags looks somehow inconsistent.
>> So all flags are here now.
>>
>> Please review. Comments and complains are quite welcome!
> 
> Sigh, it's still a pretty nasty-looking interface.  Better ideas are
> welcomed.

Maybe just a string of two-letter short names like

VmFlags: rd wr sh sr

?

I.e. in a way flags line looks in cpuinfo file.

> I joined the patches into one, massaged the changelog a bit and added a
> couple more paragraphs explaining why we're doing this to ourselves.
