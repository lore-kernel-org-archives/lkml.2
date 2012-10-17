Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2JQDf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:35:58 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46428 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQDf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <506F3987.9020902@linaro.org>
References: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org>
	<20121005181608.GA24356@core.coreip.homeip.net>
	<506F3987.9020902@linaro.org>
Date: Tue, 16 Oct 2012 20:35:56 -0700
Message-ID: <CAMP5XgdtYQxu2cp6LC0Asi5ZyGL-ARnh0pvKDi7uNeZertaHSQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        kernel-team@android.com, john.stultz@linaro.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 12:48 PM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
> On 12-10-05 12:16 PM, Dmitry Torokhov wrote:
>> On Fri, Oct 05, 2012 at 11:59:29AM -0600, mathieu.poirier@linaro.org wrote:
>>> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
>>>
>>> Andrew,
>>>
>>> After requesting a number of changes that, to my understanding
>>> have been implemented, I have not been able to get the attention
>>> of the subsystem maintainer on this patch.
>>>
>>> If there are still issues, I'm open to making changes but I want
>>> to make sure it doesn't get forgotten.  If there no objections,
>>> would you consider queuint it ?
>>
>> Mathieu,
>>
>> I have the same objection as before: using platform device solely for
>> the purpose of passing some data from board code to the driver. Surely
>> there are other ways of passing this bit of data... What about, for
>> example, making it an empty weak symbol so that board code could
>> override it with strong one?
>
> Thanks for the comments - I will implement a weak function in the
> keyreset driver.
>

A weak symbol does not work. A single kernel can support multiple
devices that have unique reset key combinations.

-- 
Arve Hjønnevåg
