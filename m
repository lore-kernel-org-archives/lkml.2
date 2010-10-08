Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0JHTB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:01:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38283
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352Ab0JHTBz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:01:55 -0400
Date: Fri, 08 Oct 2010 12:02:16 -0700 (PDT)
Message-Id: <20101008.120216.232734365.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: dilinger@queued.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] sparc: stop exporting openprom.h header
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
References: <20101008113424.2249c2df@debxo>
	<20101008.115226.179923658.davem@davemloft.net>
	<AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Oct 2010 13:00:25 -0600

> On Fri, Oct 8, 2010 at 12:52 PM, David Miller <davem@davemloft.net> wrote:
>> From: Andres Salomon <dilinger@queued.net>
>> Date: Fri, 8 Oct 2010 11:34:24 -0700
>>
>>>
>>> It's unknown why openprom.h was being exported; there doesn't seem to be any
>>> reason for it currently, and it creates headaches with userspace being able
>>> to potentially use the structures in there.  So, don't export it anymore.
>>>
>>> Signed-off-by: Andres Salomon <dilinger@queued.net>
>>
>> Acked-by: David S. Miller <davem@davemloft.net>
> 
> I suppose it makes sense for me to pick this one up into my tree so it
> is grouped with the rest of the pdt patches.  I'll pick it up once
> Andres reposts the series.

Yep, that makes sense.
