Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab1DLQx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:53:28 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64252 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab1DLQx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:53:27 -0400
Message-ID: <4DA48383.4000604@linaro.org>
Date: Tue, 12 Apr 2011 10:53:23 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality
 V2
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org> <BANLkTin7DEWJt4PrBp85disqXd9ZBG3Z_g@mail.gmail.com>
In-Reply-To: <BANLkTin7DEWJt4PrBp85disqXd9ZBG3Z_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-12 07:44 AM, Ohad Ben-Cohen wrote:
> On Mon, Apr 11, 2011 at 6:24 PM,<mathieu.poirier@linaro.org>  wrote:
>> From: Mathieu J. Poirier<mathieu.poirier@linaro.org>
>>
>> This is the second spin on STE's Hsem driver that is implemented
>> through the hwspinlock scheme.  More specifically:
>>
>>   More comments have been added in the code.
>>   Cleanup of included header files.
>>   One of the original contributor's name corrected.
>>   Calls to 'pm_runtime_disable'restored.
>>
>> Signed-off-by: Mathieu Poirier<mathieu.poirier@linaro.org>
>> ---
> Looks good, but please revise the commit log (think of a random reader
> who tries to understand what does this patch do, and is less
> interested to hear about its revisions' history).
>
> Otherwise,
>
> Acked-by: Ohad Ben-Cohen<ohad@wizery.com>
>
> (btw I assume the "PATCH 1/2" in the subject is just a typo, and
> there's no missing "PATCH 2/2")
>
Ohad,

I will revise the commit log and send a V3.  The PATCH 1/2 was generated 
by send-email even if there was only one patch file...  But you are 
correct, there was only just one patch.

Mathieu.
