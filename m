Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3ADNuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:50:44 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40883 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3ADNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130104021252.GE27589@ritirata.org>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
	<1357215562-6288-20-git-send-email-akinobu.mita@gmail.com>
	<20130104021252.GE27589@ritirata.org>
Date: Fri, 4 Jan 2013 22:50:41 +0900
Message-ID: <CAC5umyhLB++mh=-pFRzhD-YxZH2RwC5ED4g8mYxS5pYGcbxsvw@mail.gmail.com>
Subject: Re: [PATCH -v2 19/26] batman-adv: rename random32() to prandom_u32()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/4 Antonio Quartulli <ordex@autistici.org>:
> On Thu, Jan 03, 2013 at 09:19:15PM +0900, Akinobu Mita wrote:
>> Use more preferable function name which implies using a pseudo-random
>> number generator.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Acked-by: Antonio Quartulli <ordex@autistici.org>
>> Cc: Marek Lindner <lindner_marek@yahoo.de>
>> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
>> Cc: Antonio Quartulli <ordex@autistici.org>
>> Cc: b.a.t.m.a.n@lists.open-mesh.org
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> ---
>
> Hello Akinobu,
>
> as you can see in <201301021952.49979.lindner_marek@yahoo.de>, Marek Lindner
> already applied this change onto our tree. You didn't need to resend this patch
> to netdev, it will be sent by us through a future pull request.

Yes. I read Marek's email. But I included it in v2 again in order not
to break the build. Because it doesn't show up the latest linux-next yet
and the last patch 26/26 removes random32() and srandom32().

But I should have mentioned it and trimmed the Cc list.
Sorry for the confusion.
