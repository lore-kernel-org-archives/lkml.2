Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1CLPXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 10:23:46 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:45847 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1CLPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 10:23:45 -0500
Date: Sat, 12 Mar 2011 17:23:59 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@iki.fi>
X-X-Sender: aaro@loser
To: Dan Carpenter <error27@gmail.com>
cc: Aaro Koskinen <aaro.koskinen@iki.fi>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [PATCH 21/22] staging: xgifb: rename XGINew_SetRegANDOR() to
 xgifb_reg_and_or()
In-Reply-To: <20110311213740.GD2008@bicker>
Message-ID: <alpine.DEB.1.10.1103121721570.29704@loser>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi> <1299790967-7135-22-git-send-email-aaro.koskinen@iki.fi> <20110311213740.GD2008@bicker>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 12 Mar 2011, Dan Carpenter wrote:
> On Thu, Mar 10, 2011 at 11:02:46PM +0200, Aaro Koskinen wrote:
>> Rename XGINew_SetRegANDOR() to xgifb_reg_and_or().
>>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>> ---
>
>> -void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
>> -		unsigned short DataAND, unsigned short DataOR)
>> +void xgifb_reg_and_or(unsigned long port, u8 index, unsigned data_and,
>                                             ^^^^^^^^  ^^^^^^^^^^^^^^^^^
>> +		      unsigned data_or)
>                      ^^^^^^^^^^^^^^^^
> I wish the change log had mentioned some of these data type changes.  It
> doesn't cause a bug, but it still should have been mentioned.

Yes, you are right. Those cleanups were actually ment to be in a separate
patch. I will redo the patches.

Thanks,

A.
