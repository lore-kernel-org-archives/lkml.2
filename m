Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2CYHz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 03:55:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53107 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2CYHz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 03:55:56 -0400
Message-ID: <4F6ECF88.6090509@openvz.org>
Date: Sun, 25 Mar 2012 11:55:52 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
References: <20120321065140.13852.52315.stgit@zurg>  <20120321100602.GA5522@barrios> <4F69D496.2040509@openvz.org>  <20120322053958.GA5278@barrios> <1332397358.2982.82.camel@pasglop>  <4F6DDE56.3090401@openvz.org> <1332633000.2882.15.camel@pasglop>
In-Reply-To: <1332633000.2882.15.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Sat, 2012-03-24 at 18:46 +0400, Konstantin Khlebnikov wrote:
>> Obviously we can combine VM_PFN_AT_MMAP, VM_SAO, VM_GROWSUP and
>> VM_MAPPED_COPY into one.
>
> VM_PFN_AT_MMAP isn't arch specific afaik...

Technically yes, but all this pfnmap-tracking engine has only one user: x86 PAT.
We can easily make it x86-only, or try to implement it without using special flag on vma.

>
> Cheers,
> Ben.
>
>

