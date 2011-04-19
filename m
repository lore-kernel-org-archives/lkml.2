Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1DSJLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:11:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43814 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1DSJLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PQj6NFifKu5NHPBc/0Q1XiS1fPOdckPQILRvsRhNGCga8biHOZHZESwFSyxVwq3c/f
         o5qjDSNwjNawXnlPZhnUGdjIqA5Qqcjbm+Xz3rfzQhHPfAP79uwAgVg86FekmLC3UAB3
         Y+s4GUTm8w2bVMJ763BZIobZLUIRTkpQJir1A=
MIME-Version: 1.0
In-Reply-To: <201104181613.43572.arnd@arndb.de>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
	<201104181358.53521.arnd@arndb.de>
	<BANLkTimc20N0nh9O0FaSXizW+bYOMx9Ddw@mail.gmail.com>
	<201104181613.43572.arnd@arndb.de>
Date: Tue, 19 Apr 2011 18:11:00 +0900
X-Google-Sender-Auth: WJKKd6wrOZgCsq7dOHKfFd440SI
Message-ID: <BANLkTi=dpqMFjW_B5-YsmoCJf62b8djj5g@mail.gmail.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
From: Kyungmin Park <kmpark@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hari Kanigeri <h-kanigeri2@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Ramesh Gupta <grgupta@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 11:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 18 April 2011, Kyungmin Park wrote:
>> On Mon, Apr 18, 2011 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >
>> > One missing piece is still a way for a platform to provide both
>> > the iommu and the dma-mapping API in a unified driver. Right now,
>> > you have to export both interface for a generic solution.
>>
>> Actually MSM and we (Michal, Marek) tried to merge the generic IOMMU
>> implementation into mm, but MM did't accept it.
>
> I'm confused. What do you mean with MM?
linux/mm, Memory Management.

Thank you,
Kyungmin Park
>
>> So now it's implemented at each SoCs. I think it's good chance to make
>> a generic IOMMU feature for ARM consolidation.
>>
>> Before this idea, can you review our implementation at above URL?
>
> I've commented on the main implementation for the IOMMU now.
>
>        Arnd
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
