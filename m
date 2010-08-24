Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0HXCmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:42:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38699 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0HXCmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=olLc2YQ1TBkSx9ab++TZvHlTAxh9trNL8rM1YQZP6iqm8KLGBAh/qenKQutp/1lfhh
         28qzI5gvHmekwMlx/a7w==
MIME-Version: 1.0
In-Reply-To: <20100824021136.GA9254@localhost>
References: <20100821054808.GA29869@localhost> <AANLkTikS+DUfPz0E2SmCZTQBWL8h2zSsGM8--yqEaVgZ@mail.gmail.com>
 <20100824100943.F3B6.A69D9226@jp.fujitsu.com> <AANLkTi=OwGUzM0oZ5qTEFnGTuo8kVfW79oqH-Dcf8jdp@mail.gmail.com>
 <20100824021136.GA9254@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 23 Aug 2010 19:42:20 -0700
Message-ID: <AANLkTikcsqnwwNjXPPTJ3xb981Z0hopWRLEYjrE3uvQ7@mail.gmail.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 7:11 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Sorry for giving a wrong example. Hope this one is better:
>
> $ cat /debug/bdi/default/stats
> [...]
> DirtyThresh:       1838904 kB
> BackgroundThresh:   919452 kB
> [...]
>
> It's a trick to avoid messing with real devices :)

That's cool. And it's the exact code path :-)

mrubin
