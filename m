Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2J0J7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 05:59:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2J0J7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 05:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <508B9EEB.2070806@ti.com>
References: <1350920203-21978-1-git-send-email-m-karicheri2@ti.com>
 <CA+V-a8sbCyTTAm-x2Jr2_XxccRo0kjhVAYaVAibXHCqjZL7-nA@mail.gmail.com>
 <508AB1D2.40908@ti.com> <508B9EEB.2070806@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 27 Oct 2012 15:29:16 +0530
Message-ID: <CA+V-a8uLMViQvg8YKR8=m0k8hw885qqqZmF9MRjHd5w2RMjezQ@mail.gmail.com>
Subject: Re: [RESEND-PATCH] media:davinci: clk - {prepare/unprepare} for
 common clk
To: Sekhar Nori <nsekhar@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, mchehab@infradead.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Sat, Oct 27, 2012 at 2:14 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> Hi Murali,
>
> On 10/26/2012 9:22 PM, Murali Karicheri wrote:
>> On 10/25/2012 09:12 AM, Prabhakar Lad wrote:
>>> Hi Murali,
>>>
>>> Thanks for the patch.  I'll  queue this patch for 3.8.
>> Please check with Sekhar as well. This is a preparation patch for common
>> clk framework support. ALso fixes some bugs on the existing code. As the
>> clk
>> patches are dependent on these patches, I would suggest you queue this
>> against 3.7 rcx.
>
> The -rc cycle is for fixes only so this cannot get merged into v3.7
> as-is. If the patch has some fixes embedded, its a good idea to separate
> them out (and have the feature parts come after the fixes in the patch
> series) so they can be considered for -rc cycle. The current description
> does not detail what the issue is and what its impact is so when you do
> separate it out, please mention those as well. It will help determine
> the severity of the issue and convince maintainers to include it in v3.7.
>
Splitting the patch into fixes + features would make sense, Since the features
patch would again change the same piece of code changed by the fixes patch.
The fixes are not so critical enough so as to go into the rc-cycle. I think
merging in 3.8 would be a good idea.

Regards,
--Prabhakar

> Thanks,
> Sekhar
