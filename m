Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1DUAiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 20:38:23 -0400
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:43731 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab1DUAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 20:38:22 -0400
Message-ID: <4DAF7C76.4000708@thedillows.org>
Date: Wed, 20 Apr 2011 20:38:14 -0400
From: Dave Dillow <dave@thedillows.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com> <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com> <1303183934.2585.12.camel@obelisk.thedillows.org> <BANLkTi=mJgBb8Fv9xnN+qP3CWM9vkNKMyg@mail.gmail.com>
In-Reply-To: <BANLkTi=mJgBb8Fv9xnN+qP3CWM9vkNKMyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/2011 12:39 PM, Bart Van Assche wrote:
> On Tue, Apr 19, 2011 at 5:32 AM, David Dillow<dave@thedillows.org>  wrote:
>> The mapping code for ib_srp changed in 2.6.39-rc1, but it showed
>> improved IOPS for a similar setup in my testing so I'd be surprised if
>> it is the culprit. Still, it wouldn't hurt to check. Do you have time to
>> try the new ib_srp code with 2.6.38.3 to eliminate it from the equation?
> Hello Dave,
>
> I just ran a test with the most important 2.6.39-specific ib_srp
> commits reverted but that didn't yield a measurable performance
> difference for this specific test:

Thanks for giving it a whirl,
Dave
