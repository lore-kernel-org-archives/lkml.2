Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1CHChy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:37:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42081 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1CHChx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:37:53 -0500
Message-ID: <4D759675.8020600@canonical.com>
Date: Tue, 08 Mar 2011 10:37:41 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: stable@kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [stable] [PATCH] [stable-37] ideapad: read brightness setting
 when have brightness key notify
References: <1299494125-9655-1-git-send-email-ike.pan@canonical.com> <20110307161805.GB9088@kroah.com>
In-Reply-To: <20110307161805.GB9088@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 12:18 AM, Greg KH wrote:
> On Mon, Mar 07, 2011 at 06:35:25PM +0800, Ike Panhc wrote:
>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922
>>
>> On ideapad Y530, the brightness key notify will be blocked if the last notify
>> is not responsed by getting the brightness value. Read value when we get the
>> notify shall fix the problem and will not have any difference on other ideapads.
>>
>> This patch is made against 2.6.37.y and this bug impacts kernel after 2.6.37.
>>
>> The equivalent-fix patch is not in upstream yet. Since the policy of stable tree
>> is changed and .38 kernel is going to finalize.
> 
> What "policy of the stable tree is changed"?  Huh?

I thought we will have stable release on lastest kernel only[1]. Since the .38 is
going to release soon. It seems I do not have much time for .37 stable release.

I hope I do not miss something.

[1] https://lkml.org/lkml/2010/12/2/388

> 
>> I think to post this patch for stable kernel now should be a good
>> idea.
> 
> Have you not read the Documentation/stable_kernel_rules.txt and seen
> that this is totally and completly not allowed?  Why is it suddenly not
> true?
> 
> confused,

Sorry about the confusing. The same patch for upstream is posted[2] but not merged
yet. It looks like a now-or-never situation to me. That's why I post and write the
concerns in comment.

[1] https://lkml.org/lkml/2011/2/23/171

> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

