Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0HZJLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:11:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50560 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0HZJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tBpk4f04Bsme3qBrkUU0WXkb4+H3xoRMGyHkds0zz2kJm+draWXEt5/tbaV7Kn+Uml
         wnJlBiXwM7+kxlFMC4uwuJakGlxb0EupKXVQr0FM6MFkQiR/BpdJTo1h/Kb+UeyrgAeI
         7uqI0HvgBMmXtr3QL0uOz3L7qWHnQ3IxXqg+o=
MIME-Version: 1.0
In-Reply-To: <20100825235229.GC5389@nowhere>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
	<20100820152510.GA4167@elte.hu>
	<20100823085339.GA26713@elte.hu>
	<20100824171504.GI26154@erda.amd.com>
	<20100824172806.GF5723@lenovo>
	<20100824184658.GB4879@redhat.com>
	<20100824185458.GG5723@lenovo>
	<20100824195240.GA5281@lenovo>
	<20100824202718.GC4879@redhat.com>
	<20100824204038.GC5281@lenovo>
	<20100825235229.GC5389@nowhere>
Date: Thu, 26 Aug 2010 13:11:11 +0400
Message-ID: <AANLkTimANTQGTvttriG=-w=wHAKdY2JFv-DwTHifJ8N6@mail.gmail.com>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running perfctrs
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 3:52 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
...
>>
>> It seems to be different, it's pity that I had only 80x25 vga
>> mode and was unable to snap the whole log. But actually I didn't
>> even check precisely all .config options I had set since I was
>> more interested in early stage where per-cpu access should already
>> happen rather then real init'ed environmen. But I think I'll be
>> moving completely to .36 this week so we will see how it goes.
>
>
> There was a missing "return" in the end of reiserfs_evict_inode.
>
> It has been fixed there:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f4ae2faa40199b97b12f508234640bc565d166f8
>
>

Thanks for info, Frederic!
