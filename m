Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1DSMgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:36:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44669 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1DSMf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tm1orz6mGVhvxK3QXgEbfm8jJAnA6bRdL/rZgGn6+b4JF/hZ4/Tj/GpVwSKnj6bKlJ
         eaURMv1Lyiy0lBivCVj1WDmW2OYFajm5qmgSBgVQix/x9fMSN77aXAtFeuePpGWt6/o5
         kqnANu19d5bMTyGKNLifC6ew1O4D8CdLXDewI=
MIME-Version: 1.0
In-Reply-To: <201104191401.34818.arnd@arndb.de>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
	<201104181613.43572.arnd@arndb.de>
	<BANLkTi=dpqMFjW_B5-YsmoCJf62b8djj5g@mail.gmail.com>
	<201104191401.34818.arnd@arndb.de>
Date: Tue, 19 Apr 2011 21:35:56 +0900
X-Google-Sender-Auth: 8VxxG_lzYrTIkwMQTgn-R2bTkhE
Message-ID: <BANLkTim_30SbVhPLFOaq-KYwz5N6NGCe6A@mail.gmail.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
From: Kyungmin Park <kmpark@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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

On Tue, Apr 19, 2011 at 9:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 April 2011, Kyungmin Park wrote:
>> On Mon, Apr 18, 2011 at 11:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 18 April 2011, Kyungmin Park wrote:
>> >> On Mon, Apr 18, 2011 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> >
>> >> > One missing piece is still a way for a platform to provide both
>> >> > the iommu and the dma-mapping API in a unified driver. Right now,
>> >> > you have to export both interface for a generic solution.
>> >>
>> >> Actually MSM and we (Michal, Marek) tried to merge the generic IOMMU
>> >> implementation into mm, but MM did't accept it.
>> >
>> > I'm confused. What do you mean with MM?
>> linux/mm, Memory Management.
>
> I'm still confused. What were you suggesting to merge in there?
> Do you have a link to a mailing list discussion?

First, Zach Pfeffer <zpfeffer@codeaurora.org> sent the patch
https://patchwork.kernel.org/patch/108736/

Second, Michal tried it.
http://lkml.org/lkml/2010/9/6/41

http://lwn.net/Articles/403643/
https://patchwork.kernel.org/patch/157451/

Thank you,
Kyungmin Park

>
>        Arnd
>
