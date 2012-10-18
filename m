Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2JRMHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:07:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60025 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2JRMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:07:02 -0400
MIME-Version: 1.0
In-Reply-To: <507FA52E.9050400@ti.com>
References: <1350474822-7315-1-git-send-email-vinholikatti@gmail.com>
	<1350474822-7315-2-git-send-email-vinholikatti@gmail.com>
	<507FA52E.9050400@ti.com>
Date: Thu, 18 Oct 2012 17:37:01 +0530
Message-ID: <CAKVbJB_FpmbtcLr5G5sSphNOPnodZUd0sN8ha0C_RtCDtWUG=Q@mail.gmail.com>
Subject: Re: [PATCH V4 1/4] [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
From: vinayak holikatti <vinholikatti@gmail.com>
To: Venkatraman S <svenkatr@ti.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com,
        sreekumar.c@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:13 PM, Venkatraman S <svenkatr@ti.com> wrote:
> On Wednesday 17 October 2012 05:23 PM, Vinayak Holikatti wrote:
>>
>> This patch seggregates the PCI specific code in ufshcd.c to make it
>> ready for splitting into core ufs driver and PCI glue driver. Also
>> copyright header modification to remove extra warranty disclaim.
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
>> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
>> ---
>>   drivers/scsi/ufs/Kconfig  |   50 +++----
>>   drivers/scsi/ufs/ufs.h    |   42 ++----
>>   drivers/scsi/ufs/ufshcd.c |  358
>> ++++++++++++++++++++++++++-------------------
>>   drivers/scsi/ufs/ufshci.h |   42 ++----
>>   4 files changed, 256 insertions(+), 236 deletions(-)
>>
I am Vacation will look into it when i am back to work.
> This doesn't apply on 3.7-rc1. Am I missing any patches in between ?



-- 
Regards,
Vinayak Holikatti
