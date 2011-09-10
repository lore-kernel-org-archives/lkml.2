Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1IJQei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 12:34:38 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:48849 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab1IJQeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 12:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110910052207.GA4807@mwanda>
References: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
	<20110910052207.GA4807@mwanda>
Date: Sat, 10 Sep 2011 17:34:36 +0100
Message-ID: <CANK3SE1tTX=1jCCAE6r6SGuagQKo88KDM0oE4wem+VkZeOA=PQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: et131x: Fix checkpatch whitespace warnings
From: Mark Einon <mark.einon@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2011 06:22, Dan Carpenter <error27@gmail.com> wrote:
> On Sat, Sep 03, 2011 at 12:49:06PM +0100, Mark Einon wrote:
>> --- a/drivers/staging/et131x/et131x_netdev.c
>> +++ b/drivers/staging/et131x/et131x_netdev.c
>> @@ -408,7 +408,7 @@ void et131x_tx_timeout(struct net_device *netdev)
>>       unsigned long flags;
>>
>>       /* If the device is closed, ignore the timeout */
>> -     if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE));
>> +     if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE))
>>               return;
>>
>
> You fixed a bug here.  That's not mentioned in the commit message.
> Why would you want to keep that a secret?  Also it should go in a
> separate commit.

Oh yes, i did, didn't I? I must have forgot that was there.

Thanks for the spot.

Would you like it in a different patch?


Cheers,

 Mark
