Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0GLReg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:34:36 -0400
Received: from daytona.panasas.com ([67.152.220.89]:18832 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755781Ab0GLRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:34:35 -0400
Message-ID: <4C3B5226.3090507@panasas.com>
Date: Mon, 12 Jul 2010 20:34:30 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Marek <mmarek@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>	<201007052325.56971.rjw@sisk.pl>	<4C3B49B4.20300@panasas.com> <AANLkTik8MD7bWb_R38MGv3H6ct-Z3ee1x9i9sn5a_ohd@mail.gmail.com>
In-Reply-To: <AANLkTik8MD7bWb_R38MGv3H6ct-Z3ee1x9i9sn5a_ohd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2010 17:34:34.0283 (UTC) FILETIME=[7E275FB0:01CB21E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul. 12, 2010, 20:20 +0300, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 2010/7/12 Benny Halevy <bhalevy@panasas.com>:
>>
>> Not working for me either in 2.6.35-rc4.
> 
> I assume you're building with "O="? If so, have you checked -git (or
> any of the nightly snapshots)?

Correct.

> 
> Becuse it _should_ have been fixed about a week ago in commit
> 7263e715c91f ("kbuild: Fix path to scripts/setlocalversion"). But
> that's after -rc4.
> 
> (I'll do an -rc5 probably today, but it would be good to have it
> confirmed that the bug is gone)

Confirmed. This patch fixes my problem too.

Thanks!

Benny

> 
>                Linus
