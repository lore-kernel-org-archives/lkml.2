Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2JPSZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:25:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63487 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab2JPSZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com>
	<CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com>
Date: Tue, 16 Oct 2012 13:25:16 -0500
Message-ID: <CAMjP1KmGS1D6KU5hmugyPB+YZ-RhfBxjxHgMM2g3UuCvU6FgyQ@mail.gmail.com>
Subject: Re: Reading /proc/slabinfo causes stalls
From: Avleen Vig <avleen@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default we use the 2.6.32-279.5.2 as provided by CentOS.
However I also tried the 3.0.46 from elrepo:
http://elrepo.org/linux/kernel/el6/x86_64/RPMS/

The config for the 3.0 kernel is:
https://gist.github.com/3901068

They both seem to exhibit the same problem.

Thanks :)

On Tue, Oct 16, 2012 at 1:04 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Avleen,
>
> On Tue, Oct 16, 2012 at 8:51 PM, Avleen Vig <avleen@gmail.com> wrote:
>> I *think* this is the right place to ask this, and apologies if it's not
>> (is there a better place?).
>>
>> We have checks which read /proc/slabinfo once a minute, and have noticed
>> that this causes the entire system to stall for a few milliseconds.
>> It's long enough that it causes noticeable delays in latency-sensitive
>> applications (between 10ms and 100ms).
>>
>> Is this a known condition? Are there work arounds or other ways to get the
>> slab allocation data which don't cause stalls?
>
> What kernel version are you using? What does your .config look like?
