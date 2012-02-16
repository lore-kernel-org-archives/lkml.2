Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2BPLWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:22:09 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:41672 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab2BPLWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:22:07 -0500
Message-ID: <4F3CE6D8.1050703@ti.com>
Date: Thu, 16 Feb 2012 16:52:00 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 5/8] misc: emif: handle frequency and voltage change
 events
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-6-git-send-email-aneesh@ti.com> <4F3CDC9A.2000303@ti.com>
In-Reply-To: <4F3CDC9A.2000303@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 February 2012 04:08 PM, Santosh Shilimkar wrote:
> On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
>> Change SDRAM timings and other settings as necessary
>> on voltage and frequency changes. We calculate these
>> register settings based on data from the device data
>> sheet and inputs such a frequency, voltage state(stable
>> or ramping), temperature level etc.
>>
> May be you want add TBD or FIXME for notifiers when they
> are available. Do that in commit log as well as
> in the code so that we don't forget about it.

Will do.

>
>> Signed-off-by: Aneesh V<aneesh@ti.com>
>> ---
> Rest of the patch looks fine.

