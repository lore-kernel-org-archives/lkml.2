Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0HWRqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:46:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0HWRqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:46:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=kYBx/CugIttIVM4mpixja2y7ZjSg0wi0Ohdrd9AvZWqYOhXC5CgawlwWS3CL/Y7rE
	V1GIhG5gpOcuzw3fHwkcg==
MIME-Version: 1.0
In-Reply-To: <20100821004804.GA11030@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-4-git-send-email-mrubin@google.com> <20100820100855.GC8440@localhost>
 <AANLkTi=+uNFq5=5gmjfAOhngXqR8RS3dX3E2uEWG33Ot@mail.gmail.com> <20100821004804.GA11030@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 23 Aug 2010 10:45:41 -0700
Message-ID: <AANLkTim4NZrV18a2LYpyTz9+MSBgVw6KKo4tCUmu9GHZ@mail.gmail.com>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_entered_writeback in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 5:48 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> I wonder if you'll still stick to the fake NUMA scenario two years
> later -- when memcg grows powerful enough. What do we do then? "Hey
> let's rip these counters, their major consumer has dumped them.."

I think the counters will still be useful for NUMA also. Is there a
performance hit here I am missing to having the per node counters?
Just want to make sure we are only wondering about whether or not we
are polluting the interface? Also since we plan to change the name to
vmstat instead doesn't that make it more generic in the future?

mrubin
