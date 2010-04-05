Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0DEQF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668Ab0DEQFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:05:54 -0400
Message-ID: <4BBA0A13.5090703@redhat.com>
Date: Mon, 05 Apr 2010 12:04:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH] rmap: fix anon_vma_fork() memory leak
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100402112428.f46ddc44.akpm@linux-foundation.org> <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org> <4BB66941.1060809@redhat.com> <1270397575.1814.106.camel@barrios-desktop> <20100404190925.5daac2f3@annuminas.surriel.com> <alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 11:37 AM, Linus Torvalds wrote:

> This looks _very_ wrong to me.
>
> Shouldn't the unlink_anon_vmas() be in the "out_error" case?

Indeed it should.  I've had my mind somewhere else this weekend :/

New patch in the next mail.
