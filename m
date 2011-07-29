Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1G2QQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:16:40 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40580 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab1G2QQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:16:39 -0400
Message-ID: <4E32DCE3.2040708@nanometrics.ca>
Date: Fri, 29 Jul 2011 12:16:35 -0400
From: James Nuss <jamesnuss@nanometrics.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110627 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ricardo Martins <rasm@fe.up.pt>, Rodolfo Giometti <giometti@linux.it>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Igor Plyatov <plyatov@gmail.com>
Subject: Re: [PATCH v4 0/2] New PPS client driver using GPIO
References: <1311353744-16405-1-git-send-email-jamesnuss@nanometrics.ca> <20110728160835.aad5bd31.akpm@linux-foundation.org> <CAFqRFbfn==sVPdkw7LWa0M_XXXe+ry0Wi93bEP_gZz7fnYOz1A@mail.gmail.com>
In-Reply-To: <CAFqRFbfn==sVPdkw7LWa0M_XXXe+ry0Wi93bEP_gZz7fnYOz1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 07/29/2011 05:44 AM, Ricardo Martins wrote:
> On 29 July 2011 01:08, Andrew Morton<akpm@linux-foundation.org>  wrote:
>> On Fri, 22 Jul 2011 12:55:42 -0400
>> James Nuss<jamesnuss@nanometrics.ca>  wrote:
>>
>>> This patchset contains 2 patches.  It is based on the work done by
>>> Ricardo Martins<rasm@fe.up.pt>  who submitted an initial implementation [1]
>>> of a PPS IRQ client driver to the linuxpps mailing-list on Dec 3 2010.
>>
>> In which case it is rather desirable that we have Ricardo's Signed-off-by:
>> for these patches, please.

Absolutely, I should have added that from the beginning.

>
> Signed-off-by: Ricardo Martins<rasm@fe.up.pt>
>
>>

I see that you've introduced this patchset to the -mm tree with a minor 
fixup also (thanks for that). They all look good to me so now that 
Ricardo has approved the addition of his Signed-off-by, could you add 
that and submit to Linus please? Otherwise I can submit another patchset 
if that is necessary.

Regards,
James Nuss
jamesnuss@nanometrics.ca

