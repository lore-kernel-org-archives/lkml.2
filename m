Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2DQSHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:07:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35766 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2DQSHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:07:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120417173203.GA32482@tiehlicka.suse.cz>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
	<CAE9FiQXWKzv7Wo4iWGrKapmxQYtAGezghwup1UKoW2ghqUSr+A@mail.gmail.com>
	<20120417173203.GA32482@tiehlicka.suse.cz>
Date: Tue, 17 Apr 2012 11:07:10 -0700
X-Google-Sender-Auth: nnfukFOiiQfb-zlnjyDiiM7FylA
Message-ID: <CAE9FiQXvZ4eSCwMSG2H7CC6suQe37TmQpmOEKW_082W3zz-6Fw@mail.gmail.com>
Subject: Re: Weirdness in __alloc_bootmem_node_high
From: Yinghai Lu <yinghai@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 10:32 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 17-04-12 10:12:30, Yinghai Lu wrote:
>>
>> We are not using bootmem with x86 now, so could remove those workaround now.
>
> Could you be more specific about what the workaround is used for?

Don't bootmem allocating too low to use up all low memory. like for
system with lots of memory for sparse vmemmap.

when nobootmem.c is used, __alloc_bootmem_node_high is the same as
__alloc_bootmem_node.

Thanks

Yinghai
