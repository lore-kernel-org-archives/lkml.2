Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2KBUbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:31:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59906 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2KBUbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy9QSZhFpEt=iEvYTHMGhd3ARwpHfZ+PghHNAEcP6Ko7g@mail.gmail.com>
References: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com>
	<50932F6E.5060506@oracle.com>
	<CA+55aFy9QSZhFpEt=iEvYTHMGhd3ARwpHfZ+PghHNAEcP6Ko7g@mail.gmail.com>
Date: Fri, 2 Nov 2012 21:31:39 +0100
Message-ID: <CA+MoWDqZjTGTx85MhyVuD+tAb5LzbY-Yf5EKvtQXEN+3kvWjFw@mail.gmail.com>
Subject: Re: [RFC] hlist: drop the node parameter from iterators
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, paulmck@linux.vnet.ibm.com,
        dipankar@in.ibm.com, mingo@kernel.org, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 9:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Nov 1, 2012 at 7:26 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> Here are some stats:
>>
>>  - Applying the patch from -next on top of your current git head
>> results in 3 conflicts.
>>
>>  - Applying the patch from your current git head on top of v3.6 results
>> in 18 conflicts.
>>
>>  - Applying the patch from 3.6 on top of 3.5 results in 25 conflicts.
>
> Ok, that sounds slightly painful, but not unmanageable.
>
> Can you send me the actual patch, and I'll mull on this a bit more? I
> could run the coccinelle script myself, but I assume (maybe
> incorrectly?) that there are manual fixes to clean some stuff up
> afterwared..

We're working on improvements for Sasha's Coccinelle script, but need
some time to finish it.

>
>                Linus



--
Peter
