Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161846Ab2CPVup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:50:45 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:42076 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031487Ab2CPVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:50:44 -0400
Message-ID: <4F63B5AC.5080808@ti.com>
Date: Sat, 17 Mar 2012 03:20:36 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v4] misc: ddr: add LPDDR2 data from JESD209-2
References: <1331929177-11694-1-git-send-email-aneesh@ti.com> <1331931007-584-1-git-send-email-aneesh@ti.com> <20120316214334.GA24925@kroah.com>
In-Reply-To: <20120316214334.GA24925@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2012 03:13 AM, Greg KH wrote:
> On Sat, Mar 17, 2012 at 02:20:07AM +0530, Aneesh V wrote:
>> add LPDDR2 data from the JEDEC spec JESD209-2. The data
>> includes:
>>
>> 1. Addressing information for LPDDR2 memories of different
>>     densities and types(S2/S4)
>> 2. AC timing data.
>>
>> This data will useful for memory controller device drivers.
>> Right now this is used by the TI EMIF SDRAM controller
>> driver.
>>
>> Cc: Greg KH<greg@kroah.com>
>> Signed-off-by: Aneesh V<aneesh@ti.com>
>
> What happened to the other patches that depended on this one?

I was not sure what was the convention regarding re-submitting just one
patch in a series. I realize that you prefer having the whole series
again. I will send it shortly.

thanks,
Aneesh
