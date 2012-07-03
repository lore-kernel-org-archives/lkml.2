Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab2GCTC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:02:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36253 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2GCTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:02:55 -0400
MIME-Version: 1.0
In-Reply-To: <4FF2F109.2010300@lwfinger.net>
References: <1341264199.10162.2.camel@joe2Laptop>
	<1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1341310000-4082-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<4FF2F109.2010300@lwfinger.net>
Date: Tue, 3 Jul 2012 22:02:53 +0300
Message-ID: <CAHp75Vfy15PfcVYSbF5QOjdU5CqZKVMH88Ct3FKM5U2+2sAvaA@mail.gmail.com>
Subject: Re: [RFC][PATCHv2 3/3] wireless: at76c50x: eliminate hex2str()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 4:18 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/03/2012 05:06 AM, Andy Shevchenko wrote:
>>
>> The hex2str() is substituted by '%*pMF' specificator.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>   drivers/net/wireless/at76c50x-usb.c |   54
>> ++++++++---------------------------
>>   1 file changed, 12 insertions(+), 42 deletions(-)
>
>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Thanks for testing. Today I found in my mailbox (not gmail) your
previous message about compilation warnings. Are they still present?
(I guess so) Probably I need to update the patch (anyway it probably
has to be updated because we discussed with Joe about different letter
for the hex strings).


-- 
With Best Regards,
Andy Shevchenko
