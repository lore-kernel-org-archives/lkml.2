Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab2JETs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:48:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58056 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab2JETsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:48:25 -0400
Message-ID: <506F3987.9020902@linaro.org>
Date: Fri, 05 Oct 2012 13:48:23 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
References: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org> <20121005181608.GA24356@core.coreip.homeip.net>
In-Reply-To: <20121005181608.GA24356@core.coreip.homeip.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-05 12:16 PM, Dmitry Torokhov wrote:
> On Fri, Oct 05, 2012 at 11:59:29AM -0600, mathieu.poirier@linaro.org wrote:
>> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
>>
>> Andrew,
>>
>> After requesting a number of changes that, to my understanding
>> have been implemented, I have not been able to get the attention
>> of the subsystem maintainer on this patch.
>>
>> If there are still issues, I'm open to making changes but I want
>> to make sure it doesn't get forgotten.  If there no objections,
>> would you consider queuint it ?
> 
> Mathieu,
> 
> I have the same objection as before: using platform device solely for
> the purpose of passing some data from board code to the driver. Surely
> there are other ways of passing this bit of data... What about, for
> example, making it an empty weak symbol so that board code could
> override it with strong one?

Thanks for the comments - I will implement a weak function in the
keyreset driver.

Mathieu.

> 
> Thanks.
> 

