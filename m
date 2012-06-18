Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2FRTAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:00:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58393 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2FRTAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:00:48 -0400
Message-ID: <4FDF7ADC.4040207@linaro.org>
Date: Mon, 18 Jun 2012 21:00:44 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Rob Lee <rob.lee@linaro.org>, rjw@sisk.pl,
        Kevin Hilman <khilman@ti.com>, linux-next@vger.kernel.org
Subject: Re: cpuidle future and improvements
References: <4FDEE98D.7010802@linaro.org> <CAMbhsRQRFXcayyWjM1RirgFppVAK23z2+3EbYOCw-qmzuY9_2g@mail.gmail.com>
In-Reply-To: <CAMbhsRQRFXcayyWjM1RirgFppVAK23z2+3EbYOCw-qmzuY9_2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 08:15 PM, Colin Cross wrote:
> On Mon, Jun 18, 2012 at 1:40 AM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> I propose to host a cpuidle-next tree where all these modifications will
>> be and where people can send patches against, preventing last minutes
>> conflicts and perhaps Lenb will agree to pull from this tree. In the
>> meantime, the tree will be part of the linux-next, the patches will be
>> more widely tested and could be fixed earlier.
> 
> My coupled cpuidle patches were acked and temporarily in Len's
> next/Linus pull branch, but were later dropped when the first pull
> request to Linus was rejected.  I asked Len to either put the coupled
> cpuidle patches into his next branch, or let me host them so people
> could base SoC branches off of them and let Len pull them later, but
> got no response.  If you do start a cpuidle for-next branch, can you
> pull my coupled-cpuidle branch:

No problem.

Thanks
  -- Daniel

> The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
> 
>   Linux 3.4 (2012-05-20 15:29:13 -0700)
> 
> are available in the git repository at:
>   https://android.googlesource.com/kernel/common.git coupled-cpuidle
> 
> Colin Cross (4):
>       cpuidle: refactor out cpuidle_enter_state
>       cpuidle: fix error handling in __cpuidle_register_device
>       cpuidle: add support for states that affect multiple cpus
>       cpuidle: coupled: add parallel barrier function
> 
>  drivers/cpuidle/Kconfig   |    3 +
>  drivers/cpuidle/Makefile  |    1 +
>  drivers/cpuidle/coupled.c |  715 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cpuidle/cpuidle.c |   68 ++++-
>  drivers/cpuidle/cpuidle.h |   32 ++
>  include/linux/cpuidle.h   |   11 +
>  6 files changed, 813 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/cpuidle/coupled.c


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

