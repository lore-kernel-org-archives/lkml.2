Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab2IRJG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:06:26 -0400
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:41129 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932539Ab2IRJGZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:06:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 287878.84059.bm@omp1059.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=fvVxFVIDIuz9sIfQ9Yxu24xqQwN1mPTrkKfOGnVR0QQAbw4Bzo73kJVvwZq/TVMPrp2LXQdGd7Q/t+F0KPJ83uct+J8HUt4xRyLZphr1jr4matuLsdwZLiVx2KQ6izHXpIjC8rBEzRfD740iN46TE0LWiqsBCN4czhlUr62IKsU=;
X-YMail-OSG: LZUUH7cVM1lyBGBbG_92knxfeqHFmSxoF5ZpzgDOkxzxesL
 w7owX7qpOd_vcmkMY0KsuFnxOnhD0FA0Bj8jDqfuK6c1FoKX0AUZ8ZebNdAA
 TCCKGr6rvxRJGJuNQsh_oKoXUUplhzD.lGp8.dQmRcO5R7FGSDksUisQC4Tq
 VRBE9Ls0m68UlHpch.1RvClI4Pf.Knfwra9JoOL1NwTd.RXQNn9YAdTdZ4Xn
 dLjHIqw9D2Odrd5zbyFW7j7kDWAHS4o51h8tAiV82bunmirSRSAMs3RNaIRA
 SyHOg1Vn7HldKzPjyDAmjix6nYJoT939MIUWjJGHilVYyOqz.64aXsn3xkJg
 qE2WbOGdLof87WA_kbwEcMqlZmzAvDKDRTRrL2n_iDkFeDZh52Mcrb.OcbLe
 bh0XvKtgX8cGOrpV.SdXAiZD3QH0vdHoMM16y1ngmgEo5D5XPYUJe9XMzOq6
 ABBbFZc1pU0YKpxWn3k8SlMDM2ShsAe7JII_3LpXBVjoMsWXItz7axMPJDEr
 MoU4qs5P4h0Y-
X-Mailer: YahooMailWebService/0.8.121.416
References: <1347887746.22926.YahooMailNeo@web160105.mail.bf1.yahoo.com>
Message-ID: <1347959184.19552.YahooMailNeo@web160104.mail.bf1.yahoo.com>
Date: Tue, 18 Sep 2012 02:06:24 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: Info required: Tracking memcpy operation in user/kernel
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1347887746.22926.YahooMailNeo@web160105.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to track down memcpy operations of various user applications/lib or kernel modules.
In one of the scenarios there are too many memcpy operations used in our platform.
And we wanted to track which appln/lib and kernel modules doing memcpy and of what size.

If anybody is aware of any utility please let me know.

Or,
please let me know how to track memcpy from kernel space may be using some kernel module.


Thank You!
With Regards,
Pintu
 
 


>________________________________
>From: PINTU KUMAR <pintu_agarwal@yahoo.com>
>To: "linux-mm@kvack.org" <linux-mm@kvack.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org> 
>Sent: Monday, 17 September 2012 6:45 PM
>Subject: Info required: Tracking memcpy operation in user/kernel
>
>
>Hi,
>
>I wanted to track down memcpy operations of various user applications/lib or kernel modules.
>In one of the scenarios there are too many memcpy operations used in our platform.
>And we wanted to track which appln/lib and kernel modules doing memcpy and of what size.
>
>If anybody is aware of any utility please let me know.
>
>Or,
>please let me know how to track memcpy from kernel space may be using some kernel module.
>
>
>Thank You!
>With Regards,
>Pintu
> 
>
>
