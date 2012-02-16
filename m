Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2BPLze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:55:34 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39346 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab2BPLzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:55:32 -0500
Message-ID: <4F3CEEAE.40907@ti.com>
Date: Thu, 16 Feb 2012 17:25:26 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2/8] misc: ddr: add LPDDR2 data from JESD209-2
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>	<1328357771-31644-3-git-send-email-aneesh@ti.com>	<4F3CD55C.2020002@ti.com>	<4F3CDA2D.2060001@ti.com> <20120216111043.3256189f@pyramind.ukuu.org.uk>
In-Reply-To: <20120216111043.3256189f@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 February 2012 04:40 PM, Alan Cox wrote:
> On Thu, 16 Feb 2012 15:57:57 +0530
> Aneesh V<aneesh@ti.com>  wrote:
>
>> On Thursday 16 February 2012 03:37 PM, Santosh Shilimkar wrote:
>>> On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
>>>> add LPDDR2 data from the JEDEC spec JESD209-2. The data
>>>> includes:
>>>>
>>>> 1. Addressing information for LPDDR2 memories of different
>>>>      densities and types(S2/S4)
>>>> 2. AC timing data.
>>>>
>>>> This data will useful for memory controller device drivers
>
> I don't think it belongs in drivers/misc. It's not a driver but a
> library. lib/ might be a better place for it perhaps ?

Agree. I shall move it to lib/

br,
Aneesh

