Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2GKELU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 00:11:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65478 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2GKELR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 00:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <201207021517.31537.arnd@arndb.de>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
	<1341239572-7408-2-git-send-email-vinholikatti@gmail.com>
	<201207021517.31537.arnd@arndb.de>
Date: Wed, 11 Jul 2012 09:41:15 +0530
Message-ID: <CAKVbJB8KTj85_bus9NF8OMtHKDZAaDpGv1GV1FP30=H42DWwbg@mail.gmail.com>
Subject: Re: [PATCH 1/4] [SCSI] ufs: Separate PCI glue driver for ufshcd
From: vinayak holikatti <vinholikatti@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org,
        ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org,
        sreekumar.c@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 8:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 02 July 2012, Vinayak Holikatti wrote:
>>
>> This patch separates PCI and core UFS host controller driver.
>> In the current implementation PCI specific code is with ufshcd.c.
>> To provide way for adding multiple bus glue driver, this patch
>> separates PCI layer from ufshcd core. Now ufshcd compiles as separate
>> module and ufshcd-pci as separate module.
>>
>> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
>> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
>
> Hi Vinayak,
>
> This patch looks good at first sight, but it's a little hard to
> review in the form that you are posting.
>
> I would recommend that you split this patch into two separate
> changesets, where you do all the changes to existing code in the
> first patch, and only move but don't change code in the second one
> that creates the new file.
 Ok, will spilt accordinglly to make it two changesets.
>
>         Arnd
