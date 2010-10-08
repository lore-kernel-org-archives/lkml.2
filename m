Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0JHTAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:00:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57851 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0JHTAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:00:47 -0400
MIME-Version: 1.0
In-Reply-To: <20101008.115226.179923658.davem@davemloft.net>
References: <20101008173650.GH3863@angua.secretlab.ca> <20101008.104557.59696706.davem@davemloft.net>
 <20101008113424.2249c2df@debxo> <20101008.115226.179923658.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Oct 2010 13:00:25 -0600
X-Google-Sender-Auth: _1WGvIMryQyBYx63OhM0gX9UBVM
Message-ID: <AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
Subject: Re: [PATCH] sparc: stop exporting openprom.h header
To: David Miller <davem@davemloft.net>
Cc: dilinger@queued.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 12:52 PM, David Miller <davem@davemloft.net> wrote:
> From: Andres Salomon <dilinger@queued.net>
> Date: Fri, 8 Oct 2010 11:34:24 -0700
>
>>
>> It's unknown why openprom.h was being exported; there doesn't seem to be any
>> reason for it currently, and it creates headaches with userspace being able
>> to potentially use the structures in there.  So, don't export it anymore.
>>
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
>
> Acked-by: David S. Miller <davem@davemloft.net>

I suppose it makes sense for me to pick this one up into my tree so it
is grouped with the rest of the pdt patches.  I'll pick it up once
Andres reposts the series.

g.
