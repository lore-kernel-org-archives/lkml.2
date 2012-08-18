Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2HRFNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 01:13:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55566 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2HRFNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 01:13:17 -0400
MIME-Version: 1.0
X-Originating-IP: [121.7.238.199]
In-Reply-To: <20120817172130.GA940@polaris.bitmath.org>
References: <1345182286-21776-1-git-send-email-daniel@quora.org>
	<20120817172130.GA940@polaris.bitmath.org>
Date: Sat, 18 Aug 2012 13:13:16 +0800
Message-ID: <CAMVG2stkx3JX__dQ2+EnGB9fqT3wtnaGWvQFUvseK_4Jw+u+KQ@mail.gmail.com>
Subject: Re: [PATCH v3] Add device ID for Bluetooth on Macbook Pro 2012
From: Daniel J Blueman <daniel@quora.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 August 2012 01:21, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Daniel,
>
>> Add the device ID for supporting the Macbook Pro 2012 'MacBookPro10,1'.
>> The bluetooth device presents itself as:
>>
>> T:  Bus=02 Lev=04 Prnt=04 Port=02 Cnt=03 Dev#=  8 Spd=12  MxCh= 0
>> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
>> P:  Vendor=05ac ProdID=8286 Rev=00.86
>> S:  Manufacturer=Apple Inc.
>> S:  Product=Bluetooth USB Host Controller
>> C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
>> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
>> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
>> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
>> I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
>>
>> Patch originally written and tested by clipcarl (forums.opensuse.org).
>>
>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>
> I did not sign off this patch. The author is different, the subject
> and wording is different, the credits are different. It looks like you
> sent a patch which I subsequently added my SOB to, but that is not the
> case. Please do not do that.
>
> If you meant to add your blessing somehow, or if you are the unknown
> original author, adding an originally-by or tested-by or reviewed-by
> would be more appropriate.
>
> Either way, the patch is moot; With Gustavo's commit d81a5d195, the
> plan is to support this machine via a more generic device entry.

Apologies; my intent was to update your patch [1] description with the
output Marcel asked (as I have the hardware), but I clarified the
subject and description also. The actual content is identical of
course, but I should have cited your post.

Great to know Gustavo has added support.

Thanks!

Daniel

[1] https://lkml.org/lkml/2012/7/10/150
-- 
Daniel J Blueman
