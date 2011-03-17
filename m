Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1CQK4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:56:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61834 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1CQK4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q9H4fANHoUVYSgtuSQLDPI9L97GrzuXzkyNtgbBC3Mgu6i6ppuoCJiYIbH0HVJ+ti2
         P771JniJydl21O4qbZ+Qlof8+uOnDXhL+T5Te4Ae11wSB66yAPIw5j/MRAgrrqoKycyn
         pUyF2ranbI4Ts+63dUuALohZJp5XE99U8VSa8=
MIME-Version: 1.0
In-Reply-To: <1300357457.3133.92.camel@edumazet-laptop>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
 <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com> <1300357457.3133.92.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 17 Mar 2011 18:56:30 +0800
Message-ID: <AANLkTino6LzGTZF4fNSkV9pbAfnmAc8wJjk0L8HfHDiJ@mail.gmail.com>
Subject: Re: [PATCH v2] net: add Faraday FTGMAC100 Gigabit Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Mar 17, 2011 at 6:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 17 mars 2011 à 17:47 +0800, Po-Yu Chuang a écrit :
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
>> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
>> including Faraday A369 and Andes AG102.
>>
>> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
>> ---
>
> Did you tried GRO support ?

No, I don't understand how to do that yet. Let me do some study first.
I'd really appreciate it if you could provide me some pointers about GRO. :-)
Is there any document about it?

best regards,
Po-Yu Chuang
