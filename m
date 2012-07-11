Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab2GKOAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:00:25 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:39709 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab2GKOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:00:22 -0400
From: Kevin Hilman <khilman@ti.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Colin Cross <ccross@android.com>, Rob Lee <rob.lee@linaro.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-acpi@vger.kernel.org,
        linux-next@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] cpuidle future and improvements
Organization: Texas Instruments, Inc.
References: <4FDEE98D.7010802@linaro.org>
	<CAMbhsRQRFXcayyWjM1RirgFppVAK23z2+3EbYOCw-qmzuY9_2g@mail.gmail.com>
	<4FE85F6A.80307@linaro.org>
Date: Wed, 11 Jul 2012 07:00:19 -0700
In-Reply-To: <4FE85F6A.80307@linaro.org> (Daniel Lezcano's message of "Mon, 25
	Jun 2012 14:54:02 +0200")
Message-ID: <87a9z6pfd8.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

> On 06/18/2012 08:15 PM, Colin Cross wrote:
>> On Mon, Jun 18, 2012 at 1:40 AM, Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>> I propose to host a cpuidle-next tree where all these modifications will
>>> be and where people can send patches against, preventing last minutes
>>> conflicts and perhaps Lenb will agree to pull from this tree. In the
>>> meantime, the tree will be part of the linux-next, the patches will be
>>> more widely tested and could be fixed earlier.
>> 
>> My coupled cpuidle patches were acked and temporarily in Len's
>> next/Linus pull branch, but were later dropped when the first pull
>> request to Linus was rejected.  I asked Len to either put the coupled
>> cpuidle patches into his next branch, or let me host them so people
>> could base SoC branches off of them and let Len pull them later, but
>> got no response.  If you do start a cpuidle for-next branch, can you
>> pull my coupled-cpuidle branch:
>> 
>> The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
>> 
>>   Linux 3.4 (2012-05-20 15:29:13 -0700)
>> 
>> are available in the git repository at:
>>   https://android.googlesource.com/kernel/common.git coupled-cpuidle
>> 
>> Colin Cross (4):
>>       cpuidle: refactor out cpuidle_enter_state
>>       cpuidle: fix error handling in __cpuidle_register_device
>>       cpuidle: add support for states that affect multiple cpus
>>       cpuidle: coupled: add parallel barrier function
>> 
>>  drivers/cpuidle/Kconfig   |    3 +
>>  drivers/cpuidle/Makefile  |    1 +
>>  drivers/cpuidle/coupled.c |  715 +++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/cpuidle/cpuidle.c |   68 ++++-
>>  drivers/cpuidle/cpuidle.h |   32 ++
>>  include/linux/cpuidle.h   |   11 +
>>  6 files changed, 813 insertions(+), 17 deletions(-)
>>  create mode 100644 drivers/cpuidle/coupled.c
>
>
> Done.
>
> http://git.linaro.org/gitweb?p=people/dlezcano/cpuidle-next.git;a=shortlog;h=refs/heads/cpuidle-next

Great!

Daniel, thanks for tracking this.  Are you planning to submit a pull
request to Rafael so we finally can get this into linux-next and merged
for v3.6?

Looks like there will be a slight problem to sort out though.  Len's
'next' branch[1] is already included in linux-next and as some version
of the coupled CPUidle already merged.

I hope we can sort this out in time for v3.6 because this series has
been well reviewed, well tested and ready for merge since before the
v3.5 merge window.

Kevin

[1] git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux next
