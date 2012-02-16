Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2BPLZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:25:50 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54622 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab2BPLZs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:25:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120216111043.3256189f@pyramind.ukuu.org.uk>
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
 <1328357771-31644-3-git-send-email-aneesh@ti.com> <4F3CD55C.2020002@ti.com>
 <4F3CDA2D.2060001@ti.com> <20120216111043.3256189f@pyramind.ukuu.org.uk>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 16 Feb 2012 16:55:26 +0530
Message-ID: <CAMQu2gzaMC2=9hovvWRzSjrmvZioAgric-nzrrPO9fknjX818w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/8] misc: ddr: add LPDDR2 data from JESD209-2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Aneesh V <aneesh@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 4:40 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 16 Feb 2012 15:57:57 +0530
> Aneesh V <aneesh@ti.com> wrote:
>
>> On Thursday 16 February 2012 03:37 PM, Santosh Shilimkar wrote:
>> > On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
>> >> add LPDDR2 data from the JEDEC spec JESD209-2. The data
>> >> includes:
>> >>
>> >> 1. Addressing information for LPDDR2 memories of different
>> >>     densities and types(S2/S4)
>> >> 2. AC timing data.
>> >>
>> >> This data will useful for memory controller device drivers
>
> I don't think it belongs in drivers/misc. It's not a driver but a
> library. lib/ might be a better place for it perhaps ?
>
Agree for the JDEC data part. We can move this JDEC data to
lib/
Thanks for the input.

Any suggestion on the controller driver ?

Regards
Santosh
