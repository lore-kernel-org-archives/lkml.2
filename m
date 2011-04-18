Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1DRPiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:38:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59931 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DRPiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j8JYvNOFw77+sPLZsl/Otrgr1kzA65+PhoFoNoea09/9BWdvD0oxSjfClG69Smb3CJ
         YLDboxVtrmYtiUW2gOO3ZHw2xN6+WXFG62Jo6dBSCSjMMNO1q4EmVgx5fGspiYSl+Snn
         rTpl4/FUyh8oq/7ORynODDCvmOVyhxUKfL1/4=
MIME-Version: 1.0
In-Reply-To: <20110418143044.GF2466@opensource.wolfsonmicro.com>
References: <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
	<20110418143044.GF2466@opensource.wolfsonmicro.com>
Date: Mon, 18 Apr 2011 23:38:00 +0800
Message-ID: <BANLkTi=EFdzNN5GYNbGn+B8H=13C6W7s3A@mail.gmail.com>
Subject: Re: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint name
 in driver
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:30 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Apr 18, 2011 at 10:04:11PM +0800, Haojian Zhuang wrote:
>> Avoid to use constraint name in driver. So use driver_data instead to
>> store regulator name in platform driver.
>
> If this is something that's present in the current driver it should be
> fixed for 2.6.39 so should be a patch at the start of the series which
> can be applied separately to the others.
>
>> +             /* pdata->driver_data stores the name of regulator */
>> +             if (!strcmp(info->desc.name, pdata->driver_data))
>>                       break;
>
> Why not just use #defines in the header?  It'd be less error prone if
> nothing else.
>

I don't understand this. desc.name is assigned in regulator driver.
pdata->driver_data is assigned in platform driver. I need to use same
name to link them together.
